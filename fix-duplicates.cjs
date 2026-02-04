const fs = require('fs');
const path = require('path');

const pagesDir = path.join(__dirname, 'src', 'pages');

// Tüm .astro dosyalarını işle
const files = fs.readdirSync(pagesDir).filter(f => f.endsWith('.astro'));

files.forEach(file => {
    const filePath = path.join(pagesDir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    const originalLength = content.length;

    // 1. Orijinal header HTML'ini bul ve sil
    // Header pattern: <header data-elementor-type="cmsmasters_header" ... </header>
    const headerStartPattern = '<header data-elementor-type="cmsmasters_header"';
    const headerStart = content.indexOf(headerStartPattern);

    if (headerStart !== -1) {
        // Kapanış </header> tag'ını bul
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
            // Header HTML'ini sil
            content = content.substring(0, headerStart) + content.substring(headerEnd);
            console.log(`${file}: Header HTML silindi (${headerEnd - headerStart} bytes)`);
        }
    }

    // 2. Orijinal footer HTML'ini bul ve sil
    const footerStartPattern = '<footer data-elementor-type="cmsmasters_footer"';
    const footerStart = content.indexOf(footerStartPattern);

    if (footerStart !== -1) {
        // Kapanış </footer> tag'ını bul
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
            // Footer HTML'ini sil
            content = content.substring(0, footerStart) + content.substring(footerEnd);
            console.log(`${file}: Footer HTML silindi (${footerEnd - footerStart} bytes)`);
        }
    }

    // 3. Component tag'larının doğru yerde olduğundan emin ol
    // HomeHeader veya Header component'i <body> tag'ından hemen sonra olmalı
    // Footer component'i </body> tag'ından hemen önce olmalı

    // Header component tag'ı var mı kontrol et
    const hasHomeHeader = content.includes('<HomeHeader />') || content.includes('<HomeHeader/>');
    const hasHeader = content.includes('<Header />') || content.includes('<Header/>');
    const hasFooter = content.includes('<Footer />') || content.includes('<Footer/>');

    // <body ...> tag'ını bul
    const bodyMatch = content.match(/<body[^>]*>/);
    if (bodyMatch) {
        const bodyTagEnd = content.indexOf(bodyMatch[0]) + bodyMatch[0].length;

        // Header component yoksa ekle
        if (!hasHomeHeader && !hasHeader) {
            const headerComponent = file === 'index.astro' ? '<HomeHeader />' : '<Header />';
            // Body tag'ından sonra header component'i ekle
            // Ama önce cookie divleri var, onlardan sonra ekleyelim
        }
    }

    // </body> tag'ını bul
    const bodyEndPos = content.lastIndexOf('</body>');
    if (bodyEndPos !== -1) {
        // Footer component yoksa ekle
        if (!hasFooter) {
            content = content.substring(0, bodyEndPos) + '<Footer />\n' + content.substring(bodyEndPos);
        }
    }

    // Dosyayı kaydet
    if (content.length !== originalLength) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`${file}: Güncellendi (${originalLength - content.length} bytes azaldı)`);
    } else {
        console.log(`${file}: Değişiklik yapılmadı`);
    }
});

console.log('\nTamamlandı!');
