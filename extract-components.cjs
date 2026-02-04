const fs = require('fs');
const path = require('path');

const pagesDir = path.join(__dirname, 'src', 'pages');
const componentsDir = path.join(__dirname, 'src', 'components');

// Ensure components directory exists
if (!fs.existsSync(componentsDir)) {
    fs.mkdirSync(componentsDir, { recursive: true });
}

// Simple bracket matching to find closing tag
function findClosingTag(content, startPos, tagName) {
    let depth = 0;
    let i = startPos;

    while (i < content.length) {
        const openTag = content.indexOf('<' + tagName, i);
        const closeTag = content.indexOf('</' + tagName, i);

        if (closeTag === -1) {
            console.log('No closing tag found for', tagName);
            return -1;
        }

        // Check which comes first
        if (openTag !== -1 && openTag < closeTag) {
            depth++;
            i = openTag + 1;
        } else {
            if (depth === 0) {
                // Found the closing tag
                const endPos = content.indexOf('>', closeTag) + 1;
                return endPos;
            }
            depth--;
            i = closeTag + 1;
        }
    }

    return -1;
}

// Extract header from file
function extractHeader(filePath, label) {
    const content = fs.readFileSync(filePath, 'utf8');

    // Find header start
    const headerStartMatch = content.indexOf('<header data-elementor-type="cmsmasters_header"');
    if (headerStartMatch === -1) {
        console.log(`No header found in ${path.basename(filePath)}`);
        return null;
    }

    // Find the end of header
    const headerEndPos = findClosingTag(content, headerStartMatch + 1, 'header');
    if (headerEndPos === -1) {
        console.log(`Could not find closing header tag in ${path.basename(filePath)}`);
        return null;
    }

    const headerHtml = content.substring(headerStartMatch, headerEndPos);
    console.log(`Extracted ${label} header from ${path.basename(filePath)} (${headerHtml.length} chars)`);

    return {
        content: content,
        headerStart: headerStartMatch,
        headerEnd: headerEndPos,
        headerHtml: headerHtml
    };
}

// Extract footer from content
function extractFooter(content) {
    const footerStartMatch = content.indexOf('<footer data-elementor-type="cmsmasters_footer"');
    if (footerStartMatch === -1) {
        console.log('No footer found');
        return null;
    }

    const footerEndPos = findClosingTag(content, footerStartMatch + 1, 'footer');
    if (footerEndPos === -1) {
        console.log('Could not find closing footer tag');
        return null;
    }

    const footerHtml = content.substring(footerStartMatch, footerEndPos);
    console.log(`Extracted footer (${footerHtml.length} chars)`);

    return {
        footerStart: footerStartMatch,
        footerEnd: footerEndPos,
        footerHtml: footerHtml
    };
}

// Process index.astro for home header
const indexPath = path.join(pagesDir, 'index.astro');
if (fs.existsSync(indexPath)) {
    const indexResult = extractHeader(indexPath, 'home');

    if (indexResult && indexResult.headerHtml.length > 0) {
        // Save home header component
        const homeHeaderPath = path.join(componentsDir, 'HomeHeader.astro');
        fs.writeFileSync(homeHeaderPath, `---\n// Home Header Component - Transparent/Absolute positioned\n// Used on: index page\n---\n${indexResult.headerHtml}`);
        console.log(`Created ${homeHeaderPath}`);

        // Extract footer from index
        const footerResult = extractFooter(indexResult.content);
        if (footerResult && footerResult.footerHtml.length > 0) {
            const footerPath = path.join(componentsDir, 'Footer.astro');
            fs.writeFileSync(footerPath, `---\n// Footer Component\n// Shared across all pages\n---\n${footerResult.footerHtml}`);
            console.log(`Created ${footerPath}`);
        }
    }
} else {
    console.log('index.astro not found');
}

// Process about-us.astro for standard header
const aboutPath = path.join(pagesDir, 'about-us.astro');
if (fs.existsSync(aboutPath)) {
    const aboutResult = extractHeader(aboutPath, 'standard');

    if (aboutResult && aboutResult.headerHtml.length > 0) {
        // Save standard header component
        const stdHeaderPath = path.join(componentsDir, 'Header.astro');
        fs.writeFileSync(stdHeaderPath, `---\n// Standard Header Component - Normal positioned\n// Used on: about-us, services, contacts, etc.\n---\n${aboutResult.headerHtml}`);
        console.log(`Created ${stdHeaderPath}`);
    }
} else {
    console.log('about-us.astro not found');
}

console.log('\n✅ Extraction complete!');
console.log('Components directory:', componentsDir);

// List created files
const files = fs.readdirSync(componentsDir);
console.log('Created components:', files.join(', '));
