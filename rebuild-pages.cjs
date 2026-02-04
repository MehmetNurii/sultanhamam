const fs = require('fs');
const path = require('path');

const mirrorDir = path.join(__dirname, '..');
const pagesDir = path.join(__dirname, 'src', 'pages');
const componentsDir = path.join(__dirname, 'src', 'components');

// HTML dosya -> astro dosya eşleştirmesi
const pageMap = {
    'index.html': { astro: 'index.astro', headerComponent: 'HomeHeader' },
    'about-us.html': { astro: 'about-us.astro', headerComponent: 'Header' },
    'services.html': { astro: 'services.astro', headerComponent: 'Header' },
    'services-id.html': { astro: 'services-id.astro', headerComponent: 'Header' },
    'contacts.html': { astro: 'contacts.astro', headerComponent: 'Header' },
    'appointment.html': { astro: 'appointment.astro', headerComponent: 'Header' },
    'our-team.html': { astro: 'our-team.astro', headerComponent: 'Header' },
    'prices-page.html': { astro: 'prices-page.astro', headerComponent: 'Header' }
};

// Header ve footer'ı HTML'den extract et ve component tag'ları ile değiştir
function processPage(htmlFile, config) {
    const htmlPath = path.join(mirrorDir, htmlFile);
    const astroPath = path.join(pagesDir, config.astro);

    if (!fs.existsSync(htmlPath)) {
        console.log(`HATA: ${htmlPath} bulunamadı`);
        return;
    }

    let content = fs.readFileSync(htmlPath, 'utf8');
    const originalSize = content.length;

    // 1. Asset path'lerini düzelt
    content = content.replace(/href="assets\//g, 'href="/assets/');
    content = content.replace(/src="assets\//g, 'src="/assets/');
    content = content.replace(/url\(assets\//g, 'url(/assets/');
    content = content.replace(/url\('assets\//g, "url('/assets/");
    content = content.replace(/url\("assets\//g, 'url("/assets/');

    // 2. Header'ı bul ve component ile değiştir
    const headerStartPattern = '<header data-elementor-type="cmsmasters_header"';
    const headerStart = content.indexOf(headerStartPattern);

    if (headerStart !== -1) {
        let depth = 0;
        let pos = headerStart;
        let headerEnd = -1;

        while (pos < content.length) {
            if (content.substring(pos, pos + 7) === '<header') {
                depth++;
                pos += 7;
            } else if (content.substring(pos, pos + 9) === '</header>') {
                depth--;
                if (depth === 0) {
                    headerEnd = pos + 9;
                    break;
                }
                pos += 9;
            } else {
                pos++;
            }
        }

        if (headerEnd !== -1) {
            content = content.substring(0, headerStart) + `<${config.headerComponent} />` + content.substring(headerEnd);
            console.log(`  Header değiştirildi`);
        }
    }

    // 3. Footer'ı bul ve component ile değiştir
    const footerStartPattern = '<footer data-elementor-type="cmsmasters_footer"';
    const footerStart = content.indexOf(footerStartPattern);

    if (footerStart !== -1) {
        let depth = 0;
        let pos = footerStart;
        let footerEnd = -1;

        while (pos < content.length) {
            if (content.substring(pos, pos + 7) === '<footer') {
                depth++;
                pos += 7;
            } else if (content.substring(pos, pos + 9) === '</footer>') {
                depth--;
                if (depth === 0) {
                    footerEnd = pos + 9;
                    break;
                }
                pos += 9;
            } else {
                pos++;
            }
        }

        if (footerEnd !== -1) {
            content = content.substring(0, footerStart) + '<Footer />' + content.substring(footerEnd);
            console.log(`  Footer değiştirildi`);
        }
    }

    // 4. style="..." içindeki çift tırnak sorunlarını düzelt (Astro için)
    // Inline style'lar sorun çıkarabilir, gerekirse is:inline ekleyelim

    // 5. Frontmatter ekle
    const frontmatter = `---
import ${config.headerComponent} from '../components/${config.headerComponent}.astro';
import Footer from '../components/Footer.astro';
---
`;

    // 6. Script ve style tag'larına is:inline ekle (Astro uyumluluğu için)
    content = content.replace(/<script(?!.*is:inline)/g, '<script is:inline');
    content = content.replace(/<style(?!.*is:inline)/g, '<style is:inline');

    content = frontmatter + content;

    // Dosyayı kaydet
    fs.writeFileSync(astroPath, content, 'utf8');
    console.log(`${config.astro}: Oluşturuldu (${(originalSize / 1024).toFixed(1)}KB -> ${(content.length / 1024).toFixed(1)}KB)`);
}

// Tüm sayfaları işle
console.log('Sayfalar yeniden oluşturuluyor...\n');

Object.entries(pageMap).forEach(([htmlFile, config]) => {
    console.log(`İşleniyor: ${htmlFile}`);
    processPage(htmlFile, config);
    console.log('');
});

console.log('Tamamlandı!');
