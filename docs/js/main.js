/**
 * TTBaseUIKit Docs — Main JS
 * Theme management & utilities
 * [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
 */

document.addEventListener('DOMContentLoaded', () => {
    // Theme initialization
    const html = document.documentElement;
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        html.classList.add('dark');
    } else {
        html.classList.remove('dark');
    }
});
