package com.sbhs.swm.handlers;

import java.util.Date;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import com.sbhs.swm.handlers.exceptions.DuplicateException;
import com.sbhs.swm.handlers.exceptions.InvalidException;
import com.sbhs.swm.handlers.exceptions.LoginFailException;
import com.sbhs.swm.handlers.exceptions.NotFoundException;
import com.sbhs.swm.handlers.exceptions.PasswordModificationException;
import com.sbhs.swm.handlers.exceptions.VerifyPassModificationFailException;

@RestControllerAdvice
public class AppExceptionHandler {

    @ExceptionHandler(NotFoundException.class)
    @ResponseStatus(code = HttpStatus.NOT_FOUND)
    public ResponseMessage usernameNotFoundExcpetionHandler(NotFoundException exc, WebRequest request) {
        return new ResponseMessage(HttpStatus.NOT_FOUND.getReasonPhrase(), HttpStatus.NOT_FOUND.value(), new Date(),
                exc.getMessage(), request.getDescription(false));
    }

    @ExceptionHandler(LoginFailException.class)
    @ResponseStatus(code = HttpStatus.UNAUTHORIZED)
    public ResponseMessage loginFailExcpetionHandler(LoginFailException exc, WebRequest web) {
        return new ResponseMessage(HttpStatus.UNAUTHORIZED.getReasonPhrase(), HttpStatus.UNAUTHORIZED.value(),
                new Date(), exc.getMessage(), web.getDescription(false));
    }

    @ExceptionHandler(VerifyPassModificationFailException.class)
    @ResponseStatus(code = HttpStatus.UNAUTHORIZED)
    public ResponseMessage verifyPasswordModificationFailExcpetion(VerifyPassModificationFailException exc,
            WebRequest web) {
        return new ResponseMessage(HttpStatus.UNAUTHORIZED.getReasonPhrase(), HttpStatus.UNAUTHORIZED.value(),
                new Date(), exc.getMessage(), web.getDescription(false));
    }

    @ExceptionHandler(PasswordModificationException.class)
    @ResponseStatus(code = HttpStatus.LOCKED)
    public ResponseMessage passwordModificationException(PasswordModificationException exc, WebRequest web) {
        return new ResponseMessage(HttpStatus.LOCKED.getReasonPhrase(), HttpStatus.LOCKED.value(), new Date(),
                exc.getMessage(), web.getDescription(false));
    }

    @ExceptionHandler(DuplicateException.class)
    @ResponseStatus(code = HttpStatus.CONFLICT)
    public ResponseMessage duplicateException(DuplicateException exc, WebRequest web) {
        return new ResponseMessage(HttpStatus.CONFLICT.getReasonPhrase(), HttpStatus.CONFLICT.value(), new Date(),
                exc.getMessage(), web.getDescription(false));
    }

    @ExceptionHandler(InvalidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ResponseMessage invalidException(InvalidException exc, WebRequest web) {
        return new ResponseMessage(HttpStatus.BAD_REQUEST.getReasonPhrase(), HttpStatus.BAD_REQUEST.value(), new Date(),
                exc.getMessage(), web.getDescription(false));
    }
}
