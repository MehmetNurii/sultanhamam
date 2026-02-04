const fs = require('fs');
const path = require('path');

const pagesDir = path.join(__dirname, 'src', 'pages');

fs.readdirSync(pagesDir).forEach(file => {
  if (file.endsWith('.astro')) {
    const filePath = path.join(pagesDir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Script tag'leri için is:inline ekle
    // <script ... src="..." ...> -> <script is:inline ... src="..." ...>
    content = content.replace(/<script\s+(?!is:inline)/g, '<script is:inline ');
    
    // Style tag'leri için is:inline ekle (inline style'lar için)
    content = content.replace(/<style\s+(?!is:inline)/g, '<style is:inline ');
    
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Fixed: ${file}`);
  }
});

console.log('Done!');
