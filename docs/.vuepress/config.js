module.exports = {
	  theme: 'yuu',
	  title: 'Calvinball Consortium',
	  description: 'Le Calvinball Consortium est un réseau de podcasts rigolos.',
	  head: [
		['link', { rel: 'icon', href: 'favicon.png' }],
		// ['link', { rel: 'stylesheet', href: 'custom.css'}], // must be loaded after the theme
	  ],
	  themeConfig: {
		  //test: 'podcasts/calvinball'
		  search: true,
		  yuu:  {
			  defaultDarkTheme: true,
			  defaultColorTheme: 'purple',
			  colorThemes: ['purple'], // 'green', 'blue', 'red', 
			  disableThemeIgnore: true,
			  extraOptions: { // add some Vue components if you want!
				  // after: 'ToggleDarkMode',
			  },
		  },
	  }
}
