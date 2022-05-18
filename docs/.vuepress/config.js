
module.exports = {
	  theme: 'yuu',
	  title: 'Calvinball Consortium',
	  description: 'Le Calvinball Consortium est un réseau de podcasts rigolos.',
	  head: [
		['link', { rel: 'icon', href: '/favicon.png' }],
	  ],
          configureWebpack: 
			 {
			cache: {
				type: 'filesystem',
				cacheDirectory: '/media/DataXFS/yattoz/calvinball-website/webpack_cache',
			},
			module: {
				rules: [
				  {
					test: /\.m?js$/,
					exclude: /node_modules/,
					loader: 'babel-loader',
					options: {
					  cacheCompression: false,
					  cacheDirectory: true,
					},
				  },
				],
			  },
	  },
	  themeConfig: {
		  //test: 'podcasts/calvinball'
		  nav: [
			{ text: 'Emissions', link: '/podcasts/' },
			{ text: 'Les gens', link: '/people/' },
			{ text: 'En live', link: '/streams/'},
			{ text: 'Discord', link: 'https://discord.gg/4RnA9v7' },
			{ text: 'Patreon', link: 'https://www.patreon.com/calvinball'}
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
		  domain: "www.calvinballconsortium.fr"
	  },
	  plugins: {
		  '@vuepress/back-to-top' : true,
		  'seo': {
			siteTitle: (_, $site) => $site.title,
			title: $page => $page.title,
			description: $page => $page.frontmatter.description,
			author: (_, $site) => $site.themeConfig.author,
			tags: $page => $page.frontmatter.tags,
			twitterCard: _ => 'summary_large_image',
			type: $page => ['articles', 'posts', 'blog'].some(folder => $page.regularPath.startsWith('/' + folder)) ? 'article' : 'website',
			url: (_, $site, path) => ($site.themeConfig.domain || '') + path,
			image: ($page, $site) => $page.frontmatter.image && ($page.frontmatter.image.startsWith('http') ? $page.frontmatter.image : (`https://${$site.themeConfig.domain}${$page.frontmatter.image}`)),
			publishedAt: $page => $page.frontmatter.date && new Date($page.frontmatter.date),
			modifiedAt: $page => $page.frontmatter.date && new Date($page.frontmatter.date),
		  }
	  },
	  extendMarkdown: md => {
  		  md.set({ linkify: true })
 	 }
}
