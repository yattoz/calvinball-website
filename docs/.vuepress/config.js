
module.exports = {
	  theme: 'yuu',
	  title: 'Calvinball Consortium',
	  description: 'Le Calvinball Consortium est un réseau de podcasts rigolos.',
	  head: [
		['link', { rel: 'icon', href: '/favicon.png' }],
	  ],
	  themeConfig: {
		  //test: 'podcasts/calvinball'
		  nav: [
			{ text: 'Podcasts', link: '/podcasts/' },
			{ text: 'Les gens', link: '/people/' },
			{ text: 'En live', link: '/streams/'},
			{ text: 'Discord', link: 'http://discord.gg/4RnA9v7' },
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
	  },
	  plugins: {
		  '@vuepress/back-to-top' : true,
		  'seo': {
			siteTitle: (_, $site) => $site.title,
			title: $page => $page.main_title || $page.title,
			description: $page => $page.frontmatter.description,
			author: (_, $site) => $site.themeConfig.author,
			tags: $page => $page.frontmatter.tags,
			twitterCard: _ => 'summary_large_image',
			type: $page => ['articles', 'posts', 'blog'].some(folder => $page.regularPath.startsWith('/' + folder)) ? 'article' : 'website',
			url: (_, $site, path) => ($site.themeConfig.domain || '') + path,
			image: ($page, $site) => $page.frontmatter.image && (($site.themeConfig.domain && !$page.frontmatter.image.startsWith('http') || '') + $page.frontmatter.image),
			publishedAt: $page => $page.frontmatter.date && new Date($page.frontmatter.date),
			modifiedAt: $page => $page.lastUpdated && new Date($page.lastUpdated),
		  }
	  },
	  markdown: {
		  anchor: { permalink: false, permalinkBefore: false, permalinkSymbol: '#' },			
		  linkify: true
	  }
}
