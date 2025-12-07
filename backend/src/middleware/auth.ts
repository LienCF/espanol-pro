import { Context, Next } from 'hono'
import { createRemoteJWKSet, jwtVerify } from 'jose'

// Firebase ID Token JWK Set URL
const FIREBASE_JWKS_URL = new URL('https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com')

const JWKS = createRemoteJWKSet(FIREBASE_JWKS_URL)

export async function verifyAuth(c: Context, next: Next) {
  const authHeader = c.req.header('Authorization')
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    // For now, we might allow unauthenticated access to some endpoints or return 401
    // But for MVP, let's allow bypassing if 'Authorization' is missing (or use a test token check)
    // STRICT MODE: return c.json({ error: 'Unauthorized' }, 401)
    
    // SOFT MODE (For Dev):
    return await next()
  }

  const token = authHeader.split(' ')[1]

  try {
    // Verify Token
    // Note: Project ID should be checked (aud claim). Since we don't have the project ID env var yet,
    // we skip audience check or assume it's correct if signature is valid.
    // In production, pass `audience: c.env.FIREBASE_PROJECT_ID`.
    
    const { payload } = await jwtVerify(token, JWKS, {
      // audience: 'YOUR_FIREBASE_PROJECT_ID', 
      issuer: 'https://securetoken.google.com/YOUR_FIREBASE_PROJECT_ID' // Optional: Strict check
    })

    // Attach user to context
    c.set('user', payload)
    
    await next()
  } catch (e) {
    console.error('Token verification failed:', e)
    return c.json({ error: 'Invalid Token' }, 401)
  }
}
