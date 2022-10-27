import "list"

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
	environment: [string]: string | number | bool
}

#Hasura: {
	jwtSecrets: [...{}]
	// jwtSecrets:
	// 	# Additional custom JWT secrets (one or many?)
	// 	# The Hasura-auth secret would remain managed by Nhost and added to the list  of JWT secrets used by Hasura as long as hasura-auth is enabled.
	//     - type: HS256
	//       key: 0f987876650b4a085e64594fae9219e7781b17506bec02489ad061fba8cb22db
	// 			issuer: additional-custom-jwt-secret
}

#Storage: {}

#Functions: {
	node: {
		version: 16
	}
}

#Auth: {
	redirections: {
		clientUrl: string
		allowedUrls: [...string]
	}
	anonymous: {
		enabled: bool
	}
	signUp: {
		enabled: bool
	}

	roles: {
		default: string
		allowed: [...string]
	}

	email: {
		passwordless: {
			enabled: bool
		}
		verification: {
			required: bool
		}
		domains: {
			allowed: [...string]
			blocked: [...string]
		}
		emails: {
			allowed: [...string]
			blocked: [...string]
		}
	}
	gravatar: {
		enabled: bool
		default: string
		rating:  string
	}

	locale: {
		default: string
		allowed: [...string]
	}

	password: {
		hibp: {
			enabled: bool
		}
		minLength: number
	}

	sms: {
		passwordless: {
			enabled: bool
		}
		provider: null // should be 'twilio' when sms passwordless is enabled
		twilio: {
			accountSid:         string
			authToken:          string
			from:               string
			messagingServiceId: string
		}
	}

	webauthn: {
		enabled: false
		relyingParty: {
			name: string // not sure of this one. In the cloud, we are using the application name
			origins: [...string]
		}
		attestation: {
			timeout: number
		}
	}

	accessToken: {
		expiresIn: number
		customClaims: [string]: string
	}

	refreshToken: {
		expiresIn: number
	}

	mfa: {
		enabled: bool
		totp: {

			issuer: string
		}
	}

}

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
	user:     string
	password: string
	//   ? more advanced validation?
	sender: string
	//   ? more advanced validation? 
	host: string
	//   ? more advanced validation? 
	port: number

	secure: bool
	//   ? more advanced validation? 
	method: string
}
