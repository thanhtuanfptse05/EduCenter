package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class CartViewDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private List<CartItemDTO> items = new ArrayList<>();
    private BigDecimal totalFee = BigDecimal.ZERO;
    private BigDecimal discount = BigDecimal.ZERO;
    private BigDecimal finalFee = BigDecimal.ZERO;
    private int totalCourses = 0;

    private String formattedTotalFee = "0 VNĐ";
    private String formattedDiscount = "0 VNĐ";
    private String formattedFinalFee = "0 VNĐ";

    public CartViewDTO() {}

    public void recalculate() {
        totalCourses = (items != null) ? items.size() : 0;
        BigDecimal sum = BigDecimal.ZERO;
        if (items != null) {
            for (CartItemDTO it : items) {
                if (it.getFee() != null) {
                    sum = sum.add(it.getFee());
                }
            }
        }
        totalFee = sum;

        // Combo promotion rule: 10% discount if registering 2 or more courses
        if (totalCourses >= 2) {
            discount = totalFee.multiply(new BigDecimal("0.10")).setScale(0, RoundingMode.HALF_UP);
        } else {
            discount = BigDecimal.ZERO;
        }

        finalFee = totalFee.subtract(discount);
        if (finalFee.compareTo(BigDecimal.ZERO) < 0) {
            finalFee = BigDecimal.ZERO;
        }

        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,###", symbols);

        this.formattedTotalFee = df.format(totalFee) + " VNĐ";
        this.formattedDiscount = (discount.compareTo(BigDecimal.ZERO) > 0 ? "-" : "") + df.format(discount) + " VNĐ";
        this.formattedFinalFee = df.format(finalFee) + " VNĐ";
    }

    public List<CartItemDTO> getItems() { return items; }
    public void setItems(List<CartItemDTO> items) {
        this.items = (items != null) ? items : new ArrayList<>();
        recalculate();
    }

    public BigDecimal getTotalFee() { return totalFee; }
    public BigDecimal getDiscount() { return discount; }
    public BigDecimal getFinalFee() { return finalFee; }
    public int getTotalCourses() { return totalCourses; }

    public String getFormattedTotalFee() { return formattedTotalFee; }
    public String getFormattedDiscount() { return formattedDiscount; }
    public String getFormattedFinalFee() { return formattedFinalFee; }

    public boolean isEmpty() {
        return items == null || items.isEmpty();
    }
}
