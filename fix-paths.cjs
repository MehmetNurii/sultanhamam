const fs = require('fs');
const path = require('path');

const pagesDir = path.join(__dirname, 'src', 'pages');

fs.readdirSync(pagesDir).forEach(file => {
  if (file.endsWith('.astro')) {
    const filePath = path.join(pagesDir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    
    // assets/ -> /assets/ (relative to absolute)
    content = content.replace(/href="assets\//g, 'href="/assets/');
    content = content.replace(/src="assets\//g, 'src="/assets/');
    content = content.replace(/url\("assets\//g, 'url("/assets/');
    content = content.replace(/url\('assets\//g, "url('/assets/");
    
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Fixed: ${file}`);
  }
});

console.log('Done!');
