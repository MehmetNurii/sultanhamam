-- =============================================
-- PRICES PAGE MIGRATION
-- Prices page içeriklerini SQL veritabanına taşır
-- =============================================

-- Önce mevcut prices-page section'larını sil
DELETE FROM page_sections WHERE page_slug = 'prices-page';

-- Prices Page Hero Section
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, image_url, extra_data, sort_order, visible) VALUES
    ('prices-page', 'hero', 'hero',
     'Prices Page', NULL,
     'A nurturing space where mindful rituals, natural beauty, and healing touch come together to restore your glow—inside and out.',
     NULL, NULL, NULL, '{}'::jsonb, 1, true);

-- Prices Page Pricing Categories Section
-- Bu section tüm fiyatlandırma kategorilerini ve detaylarını içerir
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, image_url, extra_data, sort_order, visible) VALUES
    ('prices-page', 'pricing_categories', 'pricing',
     'Our Pricing', NULL,
     'Detailed pricing tables for various wellness and massage packages.',
     NULL, NULL, NULL,
     '{"pricing_categories": [
        {
          "title": "Massage Therapy",
          "description": "Stimulate the body''s own healing response.",
          "icon_class": "cmsms-demo-icons-wellness-bliss",
          "detail_url": "/services-page/",
          "detail_text": "View Details",
          "items": [
            {"name": "Relaxation Massage - 60 mins", "price": "$70"},
            {"name": "Relaxation Massage - 90 mins", "price": "$95"}
          ],
          "subcategories": [
            {
              "title": "Deep Tissue Massage",
              "items": [
                {"name": "60 mins", "price": "$75"},
                {"name": "90 mins", "price": "$100"}
              ]
            },
            {
              "title": "Hot Stone Massage",
              "items": [
                {"name": "60 mins", "price": "$80"},
                {"name": "90 mins", "price": "$115"}
              ]
            }
          ]
        },
        {
          "title": "Guided Meditations",
          "description": "Breathwork and mindfulness tailored to your needs.",
          "icon_class": "cmsms-demo-icons-wellness-12",
          "detail_url": "/prices-page/",
          "detail_text": "View Details",
          "groups": [
            {
              "group_title": "Initial Consultation",
              "items": [{"name": "45 mins", "price": "$50"}]
            },
            {
              "group_title": "Follow Up Treatment",
              "items": [
                {"name": "30 mins", "price": "$40"},
                {"name": "60 mins", "price": "$60"}
              ]
            }
          ]
        },
        {
          "title": "Reflexology Therapy",
          "description": "Relieve pain and limitation of movement.",
          "icon_class": "cmsms-demo-icons-wellness-15",
          "detail_url": "/prices-page/",
          "detail_text": "View Details",
          "groups": [
            {
              "group_title": "Initial Consultation",
              "items": [{"name": "45 mins", "price": "$50"}]
            },
            {
              "group_title": "Follow Up Treatment",
              "items": [
                {"name": "30 mins", "price": "$45"},
                {"name": "60 mins", "price": "$60"}
              ]
            }
          ]
        },
        {
          "title": "Lymphatic Drainage Massage",
          "description": "Gentle technique to support immune function and reduce inflammation.",
          "icon_class": "cmsms-demo-icons-wellness-8",
          "detail_url": "/prices-page/",
          "detail_text": "View Details",
          "groups": [
            {
              "group_title": "Initial Consultation",
              "items": [{"name": "45 mins", "price": "$50"}]
            },
            {
              "group_title": "Follow Up Treatment",
              "items": [
                {"name": "30 mins", "price": "$45"},
                {"name": "60 mins", "price": "$60"}
              ]
            }
          ]
        },
        {
          "title": "Aromatherapy Session",
          "description": "Deeply relax the body, mind and soul.",
          "icon_class": "cmsms-demo-icons-wellness-11",
          "detail_url": "/prices-page/",
          "detail_text": "View Details",
          "groups": [
            {
              "group_title": "Initial Consultation",
              "items": [{"name": "45 mins", "price": "$65"}]
            },
            {
              "group_title": "Follow Up Treatment",
              "items": [
                {"name": "30 mins", "price": "$50"},
                {"name": "60 mins", "price": "$80"}
              ]
            }
          ]
        }
     ]}'::jsonb, 2, true);

-- Prices Page Services Slider Section
-- Bu section "Full Range of Services" slider içeriğini içerir
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, image_url, extra_data, sort_order, visible) VALUES
    ('prices-page', 'services_slider', 'services',
     'Full Range of Services', NULL, NULL, NULL, NULL, NULL,
     '{"placeholder_image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-open-service-placeholder.webp",
       "services": [
        {
          "title": "Serenity Starter",
          "excerpt": "Recovering ability, mobility amd more",
          "description": "Designed as the perfect introduction to wellness, this gentle treatment blends light massage, calming aromatherapy, and soothing energy techniques to ease tension and quiet the mind.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-1.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-1.webp",
          "url": "/services/serenity-starter/",
          "button_text": "Read More",
          "categories": "deep-restoration-journeys packages"
        },
        {
          "title": "Swedish Relaxation Massage",
          "excerpt": "Recovering ability, mobility amd more",
          "description": "Using gentle to medium pressure and flowing strokes, this massage promotes deep relaxation, improves circulation, and soothes tired muscles.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp",
          "url": "/services/swedish-relaxation-massage/",
          "button_text": "Read More",
          "categories": "sensory-relaxation-therapies"
        },
        {
          "title": "Balance & Recenter",
          "excerpt": "Overcoming the challenges of limb loss",
          "description": "This holistic session combines guided breathwork, gentle body relaxation techniques, and subtle energy balancing to align mind, body, and spirit.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-2.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-2.webp",
          "url": "/services/balance-recenter/",
          "button_text": "Read More",
          "categories": "holistic-healing-rituals packages"
        },
        {
          "title": "Facial Massage",
          "excerpt": "Overcoming the challenges of limb loss",
          "description": "Our facial massage uses light, soothing strokes to boost circulation, release tension, and enhance your skin''s natural glow.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp",
          "url": "/services/facial-massage/",
          "button_text": "Read More",
          "categories": "sensory-relaxation-therapies"
        },
        {
          "title": "Deep Restoration",
          "excerpt": "Optimizing your individual abilities",
          "description": "This intensive therapy weaves together slow massage, therapeutic touch, and calming aromatherapy to target deep physical and emotional tension.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-3.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-3.webp",
          "url": "/services/deep-restoration/",
          "button_text": "Read More",
          "categories": "deep-restoration-journeys packages"
        },
        {
          "title": "Aromatherapy Massage",
          "excerpt": "Optimizing your individual abilities",
          "description": "This massage combines gentle, flowing techniques with the healing power of essential oils chosen specifically for your needs — whether calming, energizing, or balancing.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp",
          "url": "/services/aromatherapy-massage/",
          "button_text": "Read More",
          "categories": "sensory-relaxation-therapies"
        }
      ]}'::jsonb, 3, true);

-- =============================================
-- ÖZET: Taşınan İçerikler
-- =============================================
-- 
-- 1. HERO SECTION (PricesHeroSection.astro):
--    - Title: "Prices Page"
--    - Description: "A nurturing space where mindful rituals..."
--
-- 2. PRICING CATEGORIES (PriceListSection.astro):
--    - Massage Therapy (Relaxation, Deep Tissue, Hot Stone)
--    - Guided Meditations (Initial Consultation, Follow Up)
--    - Reflexology Therapy (Initial Consultation, Follow Up)
--    - Lymphatic Drainage Massage (Initial Consultation, Follow Up)
--    - Aromatherapy Session (Initial Consultation, Follow Up)
--
-- 3. SERVICES SLIDER (PricesServiceSlider.astro):
--    - Serenity Starter
--    - Swedish Relaxation Massage
--    - Balance & Recenter
--    - Facial Massage
--    - Deep Restoration
--    - Aromatherapy Massage
--
-- Her bir hizmet için:
--    - title, excerpt, description
--    - icon_url, bg_image_url
--    - url, button_text, categories
-- =============================================
