package com.org;

public class Booking {
    private int bookingId, allotteeId, flatId;
    private String bookingDate, possessionDate, status;
    private double totalAmount;

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getAllotteeId() { return allotteeId; }
    public void setAllotteeId(int allotteeId) { this.allotteeId = allotteeId; }
    public int getFlatId() { return flatId; }
    public void setFlatId(int flatId) { this.flatId = flatId; }
    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }
    public String getPossessionDate() { return possessionDate; }
    public void setPossessionDate(String possessionDate) { this.possessionDate = possessionDate; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}