package com.org;

public class Document {
    private int documentId, bookingId, version;
    private String docType, docName, filePath, uploadedBy, uploadDate, status;

    public int getDocumentId() { return documentId; }
    public void setDocumentId(int documentId) { this.documentId = documentId; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getVersion() { return version; }
    public void setVersion(int version) { this.version = version; }
    public String getDocType() { return docType; }
    public void setDocType(String docType) { this.docType = docType; }
    public String getDocName() { return docName; }
    public void setDocName(String docName) { this.docName = docName; }
    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    public String getUploadedBy() { return uploadedBy; }
    public void setUploadedBy(String uploadedBy) { this.uploadedBy = uploadedBy; }
    public String getUploadDate() { return uploadDate; }
    public void setUploadDate(String uploadDate) { this.uploadDate = uploadDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}