package config

import (
	"net"
	"strings"
)

#Config: {
	global:    #Global
	hasura:    #Hasura
	storage:   #Storage
	functions: #Functions
	auth:      #Auth
	smtp:      #Smtp
}

#Global: {
	// User-defined environment variables that are spread over all services
	environment: [...{
		key:   =~"[a-zA-Z_]{1,}[a-zA-Z0-9_]*"
		value: string
	}] | *[]
	// Name of the application
	name: string | *"Nhost application"
}

#Hasura: {
	jwtSecrets: [...#JWTSecret]
}

#Storage: {}

#Functions: {
	node: {
		version: 16
	}
}

#Auth: {
	redirections: {
		clientUrl: #Url | *"http://localhost:3000"
		// We should implement wildcards soon, so the #Url type should not be used here
		allowedUrls: [...string]
	}
	anonymous: {
		enabled: bool | *false
	}
	signUp: {
		enabled: bool | *true
	}

	roles: {
		default: #UserRole | *"user"
		allowed: [default, "me", ...#UserRole] | *[default, "me"]
	}

	email: {
		passwordless: {
			enabled: bool | *false
		}
		verification: {
			required: bool | *true
		}
		domains: {
			allowed: [...net.FQDN]
			blocked: [...net.FQDN]
		}
		emails: {
			allowed: [...#Email]
			blocked: [...#Email]
		}
	}
	gravatar: {
		enabled: bool | *true
		default: "404" | "mp" | "identicon" | "monsterid" | "wavatar" | "retro" | "robohash" | *"blank"
		rating:  "pg" | "r" | "x" | *"g"
	}

	locale: {
		default: #Locale | *"en"
		allowed: [default, ...#Locale] | *[default]
	}

	password: {
		hibp: {
			enabled: bool | *false
		}
		minLength: number & >=3 | *9
	}

	sms: {
		passwordless: {
			enabled: bool | *false
		}
		if (passwordless.enabled == true) {
			provider: "twilio"
			if (provider == "twilio") {
				{twilio: {
					accountSid:         string
					authToken:          string
					from:               string
					messagingServiceId: string
				}}
			}
		}
	}

	webauthn: {
		enabled: bool | *false
		if (enabled == true) {
			relyingParty: {
				name:    string
				origins: [...#Url] | *[redirections.clientUrl]
			}
			attestation: {
				timeout: number | *60000
			}
		}
	}

	accessToken: {
		expiresIn:    number | *900
		customClaims: [
				...{
				// We should ideally enforce the keys and values format here
				key:   =~"[a-zA-Z_]{1,}[a-zA-Z0-9_]*"
				value: string
			},
		] | *[]
	}

	refreshToken: {
		expiresIn: number | *43200
	}

	mfa: {
		enabled: bool | *false
		if (enabled == true) {
			totp: {
				// * Better to use the application name
				issuer: string | *null
			}
		}
	}

	providers: {
		// Will be implemented soon
		// defaults: {
		// 	signUp: {
		// 		enabled: true
		// 	}
		// }
		apple: {
			#OauthProvider
			enabled: bool | *false
			if (enabled == true) {
				clientId:   string
				keyId:      string
				teamId:     string
				privateKey: string
			}
		}
		azuread: {
			#StandardOauthProviderEnabled
			tenant: string | *"common"
		} | *#StandardOauthProviderDisabled

		bitbucket: #StandardOauthProvider
		discord:   #StandardOauthProvider
		facebook:  #StandardOauthProvider
		github:    #StandardOauthProvider
		gitlab:    #StandardOauthProvider
		google:    #StandardOauthProvider
		linkedin:  #StandardOauthProvider
		spotify:   #StandardOauthProvider
		strava:    #StandardOauthProvider
		twitch:    #StandardOauthProvider
		twitter: {
			#OauthProvider
			enabled: bool | *false
			if (enabled == true) {
				consumerKey:    string
				consumerSecret: string
			}
		}
		windowslive: #StandardOauthProvider
		workos:      {
			#StandardOauthProviderEnabled
			{domain: string} | {organization: string} | {connection: string} | *{}
		} | *#StandardOauthProviderDisabled
	}
}

#OauthProvider: {
	enabled: bool | *false
}

#StandardOauthProviderEnabled: {
	#OauthProvider
	enabled:      true
	clientId:     string
	clientSecret: string
}

#StandardOauthProviderDisabled: {
	#OauthProvider
	enabled: false
}

#StandardOauthProvider: #StandardOauthProviderEnabled | *#StandardOauthProviderDisabled

#Smtp: {
	user:     string
	password: string
	//   ? more advanced validation?
	sender: string | *"" // TODO defaults?
	host:   net.FQDN | net.IP
	port:   #Port | *1025
	secure: bool | *false
	method: "LOGIN" | *"PLAIN"
}

#UserRole: string
#Url:      string
#Port:     uint16
#Email:    =~"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
#Locale:   string & strings.MinRunes(2) & strings.MaxRunes(2)

// * https://hasura.io/docs/latest/auth/authentication/jwt/
#JWTSecret:
	({
		type: "HS384" | "HS512" | "RS256" | "RS384" | "RS512" | "Ed25519" | *"HS256"
		key:  string
	} |
	{
		jwk_url: #Url | *null
	}) &
	{
		claims_map?: {}
		claims_format?: "stringified_json" | *"json"
		audience?:      string
		issuer?:        string
		allowed_skew?:  number
		header?:        string
	} &
	({
		claims_namespace: string | *"https://hasura.io/jwt/claims"
	} |
	{
		claims_namespace_path: string
	} | *{})
