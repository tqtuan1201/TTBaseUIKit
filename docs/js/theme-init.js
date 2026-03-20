/**
 * TTBaseUIKit Docs — Theme Init (CRITICAL: loads in <head>, runs synchronously)
 * Must execute BEFORE the browser paints any pixels.
 * Sets dark class + background on <html> immediately from localStorage.
 */
(function () {
    var html = document.documentElement;
    var isDark = localStorage.theme === 'dark' ||
        (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches);

    if (isDark) {
        html.classList.add('dark');
        // Lock background on <html> BEFORE CSS loads — prevents white flash
        html.style.backgroundColor = '#0b1120';
        html.style.colorScheme = 'dark';
    } else {
        html.classList.remove('dark');
        html.style.backgroundColor = '#ffffff';
        html.style.colorScheme = 'light';
    }
})();
