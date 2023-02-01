package com.sbhs.swm.security;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;

import org.springframework.context.annotation.Configuration;
import org.springframework.util.StringUtils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.security.SignatureException;
import io.jsonwebtoken.security.Keys;

@Configuration
public class JwtConfiguration {
    @Value("${jwt.config.secret-key}")
    private String secretKey;
    @Value("${jwt.config.duration}")
    private int duration;

    public Date expireDate() {
        return Date.from(new Date().toInstant().plusMillis(duration));
    }

    public String generateJwtString(String username) {
        return Jwts.builder().setIssuedAt(new Date()).setSubject(username).setExpiration(expireDate())
                .signWith(Keys.hmacShaKeyFor(secretKey.getBytes())).compact();
    }

    public String getUsernameFromJwt(String token) {
        Claims getClaims = (Claims) Jwts.parserBuilder().setSigningKey(Keys.hmacShaKeyFor(secretKey.getBytes())).build()
                .parse(token).getBody();
        return getClaims.getSubject();
    }

    public boolean validateJwtString(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(Keys.hmacShaKeyFor(secretKey.getBytes())).build().parse(token);
            return true;
        } catch (MalformedJwtException e) {
            throw new MalformedJwtException("JWT was incorrectly constructed (and therefore invalid)");
        } catch (SignatureException e) {
            throw new SignatureException("JWS signature was discovered, but could not be verified");
        } catch (ExpiredJwtException e) {
            throw new RuntimeException(
                    "JWT is a Claims JWT and the Claims has an expiration time before the time this method is invoked");
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("JWT empty");
        }
    }

    public String getUsernameFromRequest(HttpServletRequest request) {
        String jwtFromHeader = request.getHeader("Authorization");
        if (StringUtils.hasLength(jwtFromHeader) && jwtFromHeader.startsWith("Bearer ")) {
            String jwt = jwtFromHeader.substring(7);
            if (validateJwtString(jwt))
                return getUsernameFromJwt(jwt);
            return null;
        }
        return null;
    }
}
