
module.exports = {
	  theme: 'yuu',
	  title: 'Calvinball Consortium',
	  description: 'Le Calvinball Consortium est un réseau de podcasts rigolos.',
	  head: [
		['link', { rel: 'icon', href: 'favicon.png' }],
	  ],
	  themeConfig: {
		  //test: 'podcasts/calvinball'
		  nav: [
			{ text: 'Podcasts', link: '/podcasts/' },
			{ text: 'Les gens', link: '/people/' },
			{ text: 'Contact', link: '/contact/' },
			{ text: 'Tipeee', link: 'https://fr.tipeee.com/calvinball'}
		  ],
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
