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
			  defaultColorTheme: 'red',
			  colorThemes: ['red'],
			  disableThemeIgnore: true,
			  extraOptions: {
				  // after: 'ToggleDarkMode',
			  },
		  },
	  }
}
