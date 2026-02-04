const fs = require('fs');
const path = require('path');

const pagesDir = path.join(__dirname, 'src', 'pages');

// Config for which header to use per page
const pageHeaderConfig = {
    'index.astro': 'HomeHeader', // Transparent/absolute header
    'about-us.astro': 'Header',
    'services.astro': 'Header',
    'services-id.astro': 'Header',
    'contacts.astro': 'Header',
    'appointment.astro': 'Header',
    'our-team.astro': 'Header',
    'prices-page.astro': 'Header'
};

function updatePage(filePath, headerComponent) {
    let content = fs.readFileSync(filePath, 'utf8');
    const filename = path.basename(filePath);

    // Find header position
    const headerStart = content.indexOf('<header data-elementor-type="cmsmasters_header"');
    if (headerStart === -1) {
        console.log(`No header found in ${filename}`);
        return;
    }

    // Find closing </header>
    let depth = 0;
    let headerEnd = headerStart;
    let i = headerStart;

    while (i < content.length) {
        const openTag = content.indexOf('<header', i);
        const closeTag = content.indexOf('</header>', i);

        if (closeTag === -1) break;

        if (openTag !== -1 && openTag < closeTag) {
            depth++;
            i = openTag + 1;
        } else {
            if (depth === 0) {
                headerEnd = closeTag + '</header>'.length;
                break;
            }
            depth--;
            i = closeTag + 1;
        }
    }

    // Replace header with component import
    const beforeHeader = content.substring(0, headerStart);
    const afterHeader = content.substring(headerEnd);

    // Check if there's already a frontmatter section
    const hasFrontmatter = content.trimStart().startsWith('---');

    let newContent;
    if (hasFrontmatter) {
        // Find end of frontmatter
        const fmEnd = content.indexOf('---', 3);
        if (fmEnd !== -1) {
            const fm = content.substring(0, fmEnd + 3);
            const rest = content.substring(fmEnd + 3);
            // Add import to frontmatter
            const newFm = fm.replace('---', `---\nimport ${headerComponent} from '../components/${headerComponent}.astro';`);
            // Find header in rest and replace
            const restHeaderStart = rest.indexOf('<header data-elementor-type="cmsmasters_header"');
            if (restHeaderStart !== -1) {
                // Find end in rest
                let d = 0, j = restHeaderStart, restHeaderEnd = restHeaderStart;
                while (j < rest.length) {
                    const o = rest.indexOf('<header', j);
                    const c = rest.indexOf('</header>', j);
                    if (c === -1) break;
                    if (o !== -1 && o < c) { d++; j = o + 1; }
                    else { if (d === 0) { restHeaderEnd = c + 9; break; } d--; j = c + 1; }
                }
                newContent = newFm + rest.substring(0, restHeaderStart) + `<${headerComponent} />` + rest.substring(restHeaderEnd);
            } else {
                console.log(`Could not find header in rest of ${filename}`);
                return;
            }
        }
    } else {
        // Add frontmatter with import
        const frontmatter = `---\nimport ${headerComponent} from '../components/${headerComponent}.astro';\n---\n`;
        newContent = frontmatter + beforeHeader.trimStart() + `<${headerComponent} />` + afterHeader;
    }

    // Also handle footer
    const footerStart = newContent.indexOf('<footer data-elementor-type="cmsmasters_footer"');
    if (footerStart !== -1) {
        // Find footer end
        let d = 0, k = footerStart, footerEnd = footerStart;
        while (k < newContent.length) {
            const o = newContent.indexOf('<footer', k);
            const c = newContent.indexOf('</footer>', k);
            if (c === -1) break;
            if (o !== -1 && o < c) { d++; k = o + 1; }
            else { if (d === 0) { footerEnd = c + 9; break; } d--; k = c + 1; }
        }

        // Add Footer import
        newContent = newContent.replace(
            `import ${headerComponent} from '../components/${headerComponent}.astro';`,
            `import ${headerComponent} from '../components/${headerComponent}.astro';\nimport Footer from '../components/Footer.astro';`
        );

        // Replace footer with component
        newContent = newContent.substring(0, footerStart) + '<Footer />' + newContent.substring(footerEnd);
    }

    fs.writeFileSync(filePath, newContent, 'utf8');
    console.log(`Updated ${filename} with ${headerComponent} and Footer components`);
}

// Process all pages
Object.entries(pageHeaderConfig).forEach(([pageName, headerComponent]) => {
    const pagePath = path.join(pagesDir, pageName);
    if (fs.existsSync(pagePath)) {
        updatePage(pagePath, headerComponent);
    } else {
        console.log(`Page not found: ${pageName}`);
    }
});

console.log('\n✅ All pages updated with component imports!');
