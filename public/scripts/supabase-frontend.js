// Client-side Supabase integration for dynamic content
// This script fetches site settings and navigation from Supabase
// and updates the DOM elements accordingly

const SUPABASE_URL = 'https://lqsnvgayjwvpgzssvdwz.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxxc252Z2F5and2cGd6c3N2ZHd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg2ODI1MTksImV4cCI6MjA1NDI1ODUxOX0.S-kWOmvCi3F7MxF8VnvCmJfYN9sHqneKlVCcfnc9HsI';

class SupabaseFrontend {
    constructor() {
        this.settings = {};
        this.navigation = [];
        this.isLoaded = false;
    }

    async fetchSettings() {
        try {
            const response = await fetch(`${SUPABASE_URL}/rest/v1/site_settings?select=*`, {
                headers: {
                    'apikey': SUPABASE_ANON_KEY,
                    'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
                }
            });
            const data = await response.json();

            // Convert array to object
            this.settings = data.reduce((acc, item) => {
                acc[item.key] = item.value;
                return acc;
            }, {});

            return this.settings;
        } catch (error) {
            console.error('Error fetching site settings:', error);
            return {};
        }
    }

    async fetchNavigation() {
        try {
            const response = await fetch(`${SUPABASE_URL}/rest/v1/navigation?select=*&visible=eq.true&order=sort_order.asc`, {
                headers: {
                    'apikey': SUPABASE_ANON_KEY,
                    'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
                }
            });
            this.navigation = await response.json();
            return this.navigation;
        } catch (error) {
            console.error('Error fetching navigation:', error);
            return [];
        }
    }

    async init() {
        await Promise.all([
            this.fetchSettings(),
            this.fetchNavigation()
        ]);

        this.isLoaded = true;
        this.updateDOM();

        // Dispatch custom event for other scripts to react
        window.dispatchEvent(new CustomEvent('supabaseDataLoaded', {
            detail: { settings: this.settings, navigation: this.navigation }
        }));
    }

    updateDOM() {
        this.updateContactInfo();
        this.updateSocialLinks();
        this.updateFooterInfo();
    }

    updateContactInfo() {
        // Update email links
        const emailLinks = document.querySelectorAll('a[href*="mailto:"]');
        if (this.settings.email) {
            emailLinks.forEach(link => {
                link.href = `mailto:${this.settings.email}`;
                const textEl = link.querySelector('.elementor-widget-cmsmasters-button__text');
                if (textEl) textEl.textContent = this.settings.email;
            });
        }

        // Update phone links
        const phoneLinks = document.querySelectorAll('a[href*="tel:"]');
        if (this.settings.phone) {
            phoneLinks.forEach(link => {
                link.href = `tel:${this.settings.phone.replace(/\s/g, '')}`;
                const textEl = link.querySelector('.elementor-widget-cmsmasters-button__text');
                if (textEl) textEl.textContent = this.settings.phone;
            });
        }

        // Update address text
        const addressElements = document.querySelectorAll('.cmsmasters-widget-icon-list-item-text');
        if (this.settings.address) {
            addressElements.forEach(el => {
                if (el.textContent.includes('Brooklyn') || el.textContent.includes('United States')) {
                    el.textContent = this.settings.address;
                }
            });
        }
    }

    updateSocialLinks() {
        // Update Facebook link
        if (this.settings.facebook_url) {
            const fbLinks = document.querySelectorAll('a[href*="facebook.com"]');
            fbLinks.forEach(link => link.href = this.settings.facebook_url);
        }

        // Update Instagram link
        if (this.settings.instagram_url) {
            const instaLinks = document.querySelectorAll('a[href*="instagram.com"]');
            instaLinks.forEach(link => link.href = this.settings.instagram_url);
        }

        // Update Twitter link
        if (this.settings.twitter_url) {
            const twitterLinks = document.querySelectorAll('a[href*="twitter.com"], a[href*="x.com"]');
            twitterLinks.forEach(link => link.href = this.settings.twitter_url);
        }
    }

    updateFooterInfo() {
        // Update footer text / copyright
        if (this.settings.footer_text) {
            const footerCopy = document.querySelectorAll('.elementor-widget-text-editor');
            footerCopy.forEach(el => {
                if (el.textContent.includes('©') || el.textContent.includes('Copyright')) {
                    el.innerHTML = this.settings.footer_text;
                }
            });
        }
    }

    getSetting(key) {
        return this.settings[key] || null;
    }

    getNavigation() {
        return this.navigation;
    }
}

// Initialize and expose globally
const supabaseFrontend = new SupabaseFrontend();

// Auto-initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => supabaseFrontend.init());
} else {
    supabaseFrontend.init();
}

// Expose for global access
window.supabaseFrontend = supabaseFrontend;
