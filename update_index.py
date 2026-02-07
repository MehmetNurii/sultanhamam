
import os

services_path = r'c:\Users\Nuri\Desktop\sultan2\mirror\wellness-site\src\components\ServicesSection.astro'
index_path = r'c:\Users\Nuri\Desktop\sultan2\mirror\wellness-site\src\pages\index.astro'

# Verify services file exists and has content
if not os.path.exists(services_path) or os.path.getsize(services_path) < 100:
    print("Error: ServicesSection.astro seems invalid.")
    exit(1)

with open(index_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

# indices are 0-based.
# 4321 is line 4321 in 1-based editor. so index 4320.
# 5637 is line 5637 in 1-based editor. so index 5636.
# We want to replace lines[4320:5637] (slice end is exclusive)
# slice 4320:5637 covers indices 4320 to 5636.

start_idx = 4320
end_idx = 5637 # slice end

# Verify logic:
# line 4321 (index 4320) starts with <section...
if '<section' not in lines[start_idx]:
    print(f"Warning: Line {start_idx+1} does not start with <section. It is: {lines[start_idx].strip()}")
    # proceed with caution or abort? ideally abort to be safe.
    # but maybe indentation? check "section" in line.

# line 5637 (index 5636) is </section>
if '</section>' not in lines[end_idx-1]:
    print(f"Warning: Line {end_idx} does not end with </section>. It is: {lines[end_idx-1].strip()}")

# Construct new content
new_content = lines[:start_idx]
new_content.append('<ServicesSection />\n')
new_content.extend(lines[end_idx:])

# Insert import
# Find existing imports
insert_pos = 0
for i, line in enumerate(new_content):
    if line.strip() == '---':
        if i > 0: # Second ---
            insert_pos = i
            break
if insert_pos == 0:
    insert_pos = 3 # fallback

new_content.insert(insert_pos, "import ServicesSection from '../components/ServicesSection.astro';\n")

with open(index_path, 'w', encoding='utf-8') as f:
    f.writelines(new_content)

print("Successfully updated index.astro")
