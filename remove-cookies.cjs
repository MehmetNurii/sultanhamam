const fs = require('fs');
const path = require('path');

const pagesDir = path.join(__dirname, 'src', 'pages');

// Tüm .astro dosyalarını işle
const files = fs.readdirSync(pagesDir).filter(f => f.endsWith('.astro'));

files.forEach(file => {
    const filePath = path.join(pagesDir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    const originalLength = content.length;

    // 1. Cookie consent container div'ini sil
    // <div class="cky-consent-container ... </div>
    const cookieContainerStart = content.indexOf('<div class="cky-consent-container');
    if (cookieContainerStart !== -1) {
        // Nested div'leri sayarak doğru kapanışı bul
        let depth = 0;
        let pos = cookieContainerStart;
        let cookieContainerEnd = -1;

        while (pos < content.length) {
            if (content.substring(pos, pos + 4) === '<div') {
                depth++;
                pos += 4;
            } else if (content.substring(pos, pos + 6) === '</div>') {
                depth--;
                if (depth === 0) {
                    cookieContainerEnd = pos + 6;
                    break;
                }
                pos += 6;
            } else {
                pos++;
            }
        }

        if (cookieContainerEnd !== -1) {
            content = content.substring(0, cookieContainerStart) + content.substring(cookieContainerEnd);
        }
    }

    // 2. Cookie overlay div'ini sil
    // <div class="cky-overlay cky-hide"></div>
    content = content.replace(/<div class="cky-overlay[^"]*"><\/div>/g, '');

    // 3. Cookie modal div'ini sil
    // <div class="cky-modal" ... </div>
    const cookieModalStart = content.indexOf('<div class="cky-modal"');
    if (cookieModalStart !== -1) {
        let depth = 0;
        let pos = cookieModalStart;
        let cookieModalEnd = -1;

        while (pos < content.length) {
            if (content.substring(pos, pos + 4) === '<div') {
                depth++;
                pos += 4;
            } else if (content.substring(pos, pos + 6) === '</div>') {
                depth--;
                if (depth === 0) {
                    cookieModalEnd = pos + 6;
                    break;
                }
                pos += 6;
            } else {
                pos++;
            }
        }

        if (cookieModalEnd !== -1) {
            content = content.substring(0, cookieModalStart) + content.substring(cookieModalEnd);
        }
    }

    // 4. Cookie CSS'ini sil (cky-style id'li style bloğu)
    const ckyStyleStart = content.indexOf('<style is:inline id="cky-style">');
    if (ckyStyleStart !== -1) {
        const ckyStyleEnd = content.indexOf('</style>', ckyStyleStart) + 8;
        if (ckyStyleEnd !== -1) {
            content = content.substring(0, ckyStyleStart) + content.substring(ckyStyleEnd);
        }
    }

    // 5. Cookie JS config'ini sil
    // <script ... id="cookie-law-info-js-extra"> ... </script>
    const cookieJsStart = content.indexOf('<script is:inline type="text/javascript" id="cookie-law-info-js-extra">');
    if (cookieJsStart !== -1) {
        const cookieJsEnd = content.indexOf('</script>', cookieJsStart) + 9;
        if (cookieJsEnd !== -1) {
            content = content.substring(0, cookieJsStart) + content.substring(cookieJsEnd);
        }
    }

    // 6. _ckyStyles değişkeni tanımlayan inline CSS'i de kaldır
    content = content.replace(/var _ckyStyles = \{[^}]+\};/g, '');
    content = content.replace(/var _ckyConfig = \{[\s\S]*?\};/g, '');

    // Dosyayı kaydet
    if (content.length !== originalLength) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`${file}: Cookie öğeleri silindi (${originalLength - content.length} bytes azaldı)`);
    } else {
        console.log(`${file}: Cookie öğesi bulunamadı`);
    }
});

console.log('\nTamamlandı!');
