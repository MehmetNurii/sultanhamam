
const fs = require('fs');
const path = require('path');

const servicesPath = String.raw`c:\Users\Nuri\Desktop\sultan2\mirror\wellness-site\src\components\ServicesSection.astro`;
const indexPath = String.raw`c:\Users\Nuri\Desktop\sultan2\mirror\wellness-site\src\pages\index.astro`;

if (!fs.existsSync(servicesPath)) {
    console.error("Error: ServicesSection.astro not found.");
    process.exit(1);
}

const content = fs.readFileSync(indexPath, 'utf-8');
const lines = content.split(/\r?\n/);

// indices are 0-based.
// 4321 is line 4321 in 1-based editor. so index 4320.
// 5637 is line 5637 in 1-based editor. so index 5636.
// We want to replace lines[4320:5637] inclusive.

const startIdx = 4320;
const endIdx = 5636; // Inclusive end index to remove

// Check if file is long enough
if (lines.length <= endIdx) {
    console.error(`Error: File is too short (${lines.length} lines) to modify lines ${startIdx}-${endIdx}`);
    process.exit(1);
}

if (!lines[startIdx].includes('<section')) {
    console.warn(`Warning: Line ${startIdx + 1} does not start with <section. It is: ${lines[startIdx]}`);
}

if (!lines[endIdx].includes('</section>')) {
    console.warn(`Warning: Line ${endIdx + 1} does not end with </section>. It is: ${lines[endIdx]}`);
}

// Remove lines from startIdx to endIdx (inclusive)
// splice(start, deleteCount, item1...)
// deleteCount = endIdx - startIdx + 1
const deleteCount = endIdx - startIdx + 1;

lines.splice(startIdx, deleteCount, '<ServicesSection />');

// Insert import
let insertPos = 0;
let dashCount = 0;
for (let i = 0; i < lines.length; i++) {
    if (lines[i].trim() === '---') {
        dashCount++;
        if (dashCount === 2) {
            insertPos = i;
            break;
        }
    }
}
if (insertPos === 0) insertPos = 3; // Fallback

lines.splice(insertPos, 0, "import ServicesSection from '../components/ServicesSection.astro';");

fs.writeFileSync(indexPath, lines.join('\n'), 'utf-8');
console.log("Successfully updated index.astro");
