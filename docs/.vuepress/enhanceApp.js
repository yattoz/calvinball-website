import 'bootstrap/dist/css/bootstrap.min.css'

import 'shikwasa/dist/shikwasa.min.css'


export default ({
  Vue, // the version of Vue being used in the VuePress app
  options, // the options for the root Vue instance
  router, // the router instance for the app
  siteData // site metadata
}) => {
  Vue.prototype.$podloveTheme = {
    "leretourdujeudi": {
        theme: {
          "tokens": {
            "brand": "#9115E6FF",
            "brandDark": "#582373FF",
            "brandDarkest": "#3C1A4AFF",
            "brandLightest": "#CFAAE5FF",
            "shadeDark": "#807E7C",
            "shadeBase": "#807E7C",
            "contrast": "#000",
            "alt": "#fff"
          }
        }
      },
      "calvinball": {
        theme: {
          "tokens": {
            "brand": "#6B4300FF",
            "brandDark": "#86431AFF",
            "brandDarkest": "#4A361AFF",
            "brandLightest": "#FBE8D3FF",
            "shadeDark": "#807E7C",
            "shadeBase": "#807E7C",
            "contrast": "#000",
            "alt": "#fff"
          }
        }
      },
      "recommande": {
        theme: {
          "tokens": {
            "brand": "#0D2FA3FF",
            "brandDark": "#234173FF",
            "brandDarkest": "#1A274AFF",
            "brandLightest": "#B4D2F3FF",
            "shadeDark": "#807E7C",
            "shadeBase": "#807E7C",
            "contrast": "#000",
            "alt": "#fff"
          }
        }
      }
	  }

}