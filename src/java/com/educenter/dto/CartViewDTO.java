package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/** Display data only; CartService supplies the calculated listed-fee total. */
public class CartViewDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    private List<CartItemDTO> items = new ArrayList<>();
    private BigDecimal totalFee = BigDecimal.ZERO;
    public CartViewDTO() { }
    public CartViewDTO(List<CartItemDTO> items, BigDecimal totalFee) {
        this.items = new ArrayList<>(items); this.totalFee = totalFee;
    }
    public List<CartItemDTO> getItems() { return items; }
    public int getTotalCourses() { return items.size(); }
    public BigDecimal getTotalFee() { return totalFee; }
    public String getFormattedTotalFee() { return NumberFormat.getIntegerInstance(Locale.forLanguageTag("vi-VN")).format(totalFee) + " VNĐ"; }
    public boolean isEmpty() { return items.isEmpty(); }
    public boolean isCheckoutReady() { return !items.isEmpty() && items.stream().allMatch(CartItemDTO::isAvailable); }
}
