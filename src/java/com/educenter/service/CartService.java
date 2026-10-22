package com.educenter.service;

import com.educenter.dto.CartViewDTO;
import com.educenter.dto.RegistrationCheckoutDTO;
import jakarta.servlet.http.HttpSession;

public interface CartService {

    /**
     * Retrieve the current registration cart, supporting guest session and authenticated user database synchronization.
     */
    CartViewDTO getCart(HttpSession session, Long userId);

    /**
     * Add a course to the registration cart.
     */
    void addToCart(HttpSession session, Long userId, Long courseId, String notes);

    /**
     * Remove a course from the registration cart.
     */
    void removeFromCart(HttpSession session, Long userId, Long courseId);

    /**
     * Clear all courses from the registration cart.
     */
    void clearCart(HttpSession session, Long userId);

    /**
     * Confirm registration request, convert into CRM Lead, clear cart and return generated lead reference code.
     */
    String confirmRegistration(HttpSession session, Long userId, RegistrationCheckoutDTO checkoutDTO);
}
