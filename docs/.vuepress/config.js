module.exports = {
	  theme: 'yuu',
	  title: 'Calvinball Consortium',
	  description: 'Le Calvinball Consortium est un réseau de podcasts rigolos.',
	  head: [
		['link', { rel: 'icon', href: 'favicon.png' }],
	  ],
	  themeConfig: {
		  //test: 'podcasts/calvinball'
		  search: true,
		  yuu:  {
			  defaultDarkTheme: false,
			  defaultColorTheme: 'green',
			  colorThemes: ['purple', 'blue', 'red'], 
			  disableThemeIgnore: true,
			  extraOptions: { // add some Vue components if you want!
				  // after: 'ToggleDarkMode',
			  },
		  },
	  }
}
