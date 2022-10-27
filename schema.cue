import "list"

import "strings"

#Root: {
	global:    #Global
	hasura:    #Hasura
	storage:   #Storage
	functions: #Functions
	auth:      #Auth
	smtp:      #Smtp
}

#Global: {
	// User-defined environment variables that are spread over all services
	environment: [#EnvironmentVariable]: string | number | bool
	// Name of the application
	name: string | *"Nhost application" // TODO no defaults?
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
		// TODO we should implement wildcards soon
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
		allowed: [...#UserRole] | *[default, "me"]
	}

	email: {
		passwordless: {
			enabled: bool | *false
		}
		verification: {
			required: bool | *true
		}
		domains: {
			allowed: [...#Domain]
			blocked: [...#Domain]
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
		allowed: [...#Locale] | *[locale]
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
		provider: "twilio" | *null
		// TODO: required if provider is set to "twilio"
		twilio: {
			accountSid:         string | *'' // TODO no default?
			authToken:          string | *'' // TODO no default?
			from:               string | *'' // TODO no default?
			messagingServiceId: string | *'' // TODO no default?
		}
	}

	webauthn: {
		enabled: bool | *false
		relyingParty: {
			// ! In the cloud, we are using the application name
			// name: string
			// TODO to be further analysed
			origins: [...string]
		}
		attestation: {
			timeout: number | *60000
		}
	}

	accessToken: {
		expiresIn: number | *900
		customClaims: [string]: string // TODO we could do better than string:string
	}

	refreshToken: {
		expiresIn: number | *43200
	}

	mfa: {
		enabled: bool | *false
		// TODO: required if mfa is enabled
		totp: {
			// ! probably better to use the application name
			// issuer: string | *null
		}
	}

}

// TODO providers
//   providers:
//     apple:
//       enabled: false
//       clientId: ''
//       keyId: ''
//       privateKey: ''
//       scope:
//         - name
//         - email
//       teamId: ''
//     bitbucket:
//       enabled: false
//       clientId: ''
//       clientSecret: ''
//     facebook:
//       enabled: false
//       clientId: ''
//       clientSecret: ''
//       scope:
//         - email
//         - photos
//         - displayName
// 		# ... and other OAuth providers ...

#Smtp: {
	user:     string | *'' // TODO defaults?
	password: string | *'' // TODO defaults?
	//   ? more advanced validation?
	sender: string | *''        // TODO defaults?
	host:   #Domain | #Ip | *'' // TODO defaults?
	port:   #Port | *1025       // TODO defaults?
	secure: bool | *false
	method: "LOGIN" | *"PLAIN"
}

#EnvironmentVariable: =~"[a-zA-Z_]{1,}[a-zA-Z0-9_]*"
#UserRole:            string
#Url:                 string
#Ip:                  string
#Domain:              string
#Port:                uint16
#Email:               =~"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
#Locale:              string & strings.MinRunes(2) & strings.MaxRunes(2)

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
	} |
	{})
