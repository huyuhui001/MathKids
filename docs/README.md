# MathKid GitHub Pages Documentation

This directory contains the GitHub Pages website for the MathKid project.

## Files

- `index.html` - Main landing page for the GitHub Pages site
- `styles.css` - Stylesheet for the website
- `README.md` - This file

## Setup Instructions

To enable GitHub Pages for this repository:

1. Go to your repository on GitHub
2. Click on **Settings**
3. Scroll down to **Pages** section in the left sidebar
4. Under **Source**, select:
   - Branch: `main` (or your default branch)
   - Folder: `/docs`
5. Click **Save**
6. Wait a few minutes for GitHub to build and deploy your site
7. The site will be available at: `https://huyuhui001.github.io/MathKids/`

## Features

The GitHub Pages site includes:

- **Hero Section** - Introduction to MathKid app with badges
- **Features Section** - Key features of the app (bilingual)
- **Math Categories** - Table showing all 8 math operation types
- **Technology Stack** - Technical details about the app
- **Download Section** - System requirements and download links
- **Documentation** - Links to detailed documentation in README
- **Contributing** - Guide for contributors
- **Footer** - Links and license information

## Customization

To customize the website:

1. Edit `index.html` to change content
2. Edit `styles.css` to modify styling
3. Commit and push changes
4. GitHub will automatically rebuild the site

## Local Development

To preview the site locally:

1. Open `index.html` in your web browser
2. Or use a local server:

   ```bash
   # Using Python
   python -m http.server 8000
   
   # Using Node.js (with npx)
   npx serve
   ```

3. Navigate to `http://localhost:8000` (or the appropriate port)

## Responsive Design

The website is fully responsive and optimized for:

- Desktop (1200px+)
- Tablet (768px - 1199px)
- Mobile (< 768px)

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## License

Same as the main project - MIT License
