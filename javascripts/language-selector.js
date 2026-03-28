// Language Selector with Flags
// Detecta el idioma actual y muestra el selector de idioma con banderas

document.addEventListener("DOMContentLoaded", function() {
    // Detectar idioma actual basado en la URL
    const currentPath = window.location.pathname;
    let currentLang = 'es'; // Por defecto español

    if (currentPath.startsWith('/en/')) {
        currentLang = 'en';
    } else if (currentPath.startsWith('/fr/')) {
        currentLang = 'fr';
    }

    // Configuración de idiomas
    const languages = {
        es: {
            name: 'Español',
            flag: 'img-shared/bandera_es.png',
            path: '/'
        },
        en: {
            name: 'English',
            flag: 'img-shared/bandera_en.png',
            path: '/en/'
        },
        fr: {
            name: 'Français',
            flag: 'img-shared/bandera_fr.png',
            path: '/fr/'
        }
    };

    // Crear selector de idioma si no existe
    if (!document.querySelector('.language-selector-container')) {
        const header = document.querySelector('.md-header__inner') || document.querySelector('header');

        if (header) {
            const selectorContainer = document.createElement('div');
            selectorContainer.className = 'language-selector-container';

            // Crear botón del idioma actual
            const currentFlag = document.createElement('img');
            currentFlag.src = languages[currentLang].flag;
            currentFlag.alt = languages[currentLang].name;
            currentFlag.className = 'current-language-flag';
            currentFlag.style.cssText = `
                height: 24px;
                width: 32px;
                object-fit: cover;
                border-radius: 3px;
                cursor: pointer;
                border: 2px solid rgba(0,0,0,0.2);
                transition: all 0.3s ease;
            `;

            // Crear dropdown con otros idiomas
            const dropdown = document.createElement('div');
            dropdown.className = 'language-dropdown';
            dropdown.style.cssText = `
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                padding: 8px 0;
                display: none;
                z-index: 1000;
                min-width: 150px;
            `;

            // Añadir opciones de idioma
            Object.keys(languages).forEach(lang => {
                if (lang !== currentLang) {
                    const option = document.createElement('a');
                    option.href = languages[lang].path;
                    option.className = 'language-option';
                    option.style.cssText = `
                        display: flex;
                        align-items: center;
                        padding: 10px 16px;
                        text-decoration: none;
                        color: var(--md-typeset-color);
                        transition: background 0.2s ease;
                        gap: 12px;
                    `;

                    const flag = document.createElement('img');
                    flag.src = languages[lang].flag;
                    flag.alt = languages[lang].name;
                    flag.style.cssText = `
                        height: 20px;
                        width: 26px;
                        object-fit: cover;
                        border-radius: 2px;
                        border: 1px solid rgba(0,0,0,0.1);
                    `;

                    const name = document.createElement('span');
                    name.textContent = languages[lang].name;
                    name.style.cssText = `
                        font-size: 14px;
                        font-weight: 500;
                    `;

                    option.appendChild(flag);
                    option.appendChild(name);

                    // Hover effect
                    option.addEventListener('mouseenter', function() {
                        option.style.background = 'rgba(0,0,0,0.05)';
                    });

                    option.addEventListener('mouseleave', function() {
                        option.style.background = 'transparent';
                    });

                    dropdown.appendChild(option);
                }
            });

            // Toggle dropdown
            currentFlag.addEventListener('click', function(e) {
                e.stopPropagation();
                const isVisible = dropdown.style.display === 'block';
                dropdown.style.display = isVisible ? 'none' : 'block';
            });

            // Cerrar dropdown al hacer clic fuera
            document.addEventListener('click', function() {
                dropdown.style.display = 'none';
            });

            selectorContainer.appendChild(currentFlag);
            selectorContainer.appendChild(dropdown);

            // Posicionar el selector
            selectorContainer.style.cssText = `
                position: relative;
                display: inline-block;
                margin-left: 16px;
            `;

            // Añadir al header
            const headerRight = document.querySelector('.md-header__title') ||
                               document.querySelector('.md-header__options');
            if (headerRight) {
                headerRight.style.display = 'flex';
                headerRight.style.alignItems = 'center';
                headerRight.style.gap = '16px';
                headerRight.appendChild(selectorContainer);
            } else {
                header.appendChild(selectorContainer);
            }
        }
    }

    // Guardar preferencia de idioma en localStorage
    const languageLinks = document.querySelectorAll('a[href^="/en/"], a[href^="/fr/"], a[href="/"]');
    languageLinks.forEach(link => {
        link.addEventListener('click', function() {
            const lang = this.getAttribute('href').match(/^\/([a-z]{2})\//);
            if (lang) {
                localStorage.setItem('preferredLanguage', lang[1]);
            } else {
                localStorage.setItem('preferredLanguage', 'es');
            }
        });
    });

    // Redirigir al idioma preferido si está en la raíz
    if (currentPath === '/' || currentPath === '') {
        const preferredLang = localStorage.getItem('preferredLanguage');
        if (preferredLang && preferredLang !== 'es') {
            // No redirigir automáticamente, solo marcar preferencia para futuras visitas
            console.log('Idioma preferido:', preferredLang);
        }
    }
});

// Estilos adicionales para el modo oscuro
const style = document.createElement('style');
style.textContent = `
    [data-md-color-scheme="slate"] .language-dropdown {
        background: var(--md-default-bg-color);
        border: 1px solid var(--md-default-fg-color--lightest);
    }

    [data-md-color-scheme="slate"] .language-option {
        color: var(--md-default-fg-color);
    }

    [data-md-color-scheme="slate"] .language-option:hover {
        background: rgba(255,255,255,0.05);
    }

    .current-language-flag:hover {
        transform: scale(1.05);
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }

    @media (max-width: 768px) {
        .language-selector-container {
            margin-left: 8px;
        }

        .current-language-flag {
            height: 20px;
            width: 26px;
        }

        .language-dropdown {
            right: -8px;
        }
    }
`;
document.head.appendChild(style);
