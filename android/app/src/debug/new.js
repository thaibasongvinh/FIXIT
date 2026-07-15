match /bookings/{bookingId} {
  // Hàm kiểm tra chuyển đổi trạng thái
  function isValidTransition(oldS, newS) {
    return (oldS == 'pending' && (newS == 'accepted' || newS == 'cancelled')) ||
           (oldS == 'accepted' && (newS == 'in_progress' || newS == 'cancelled')) ||
           (oldS == 'in_progress' && newS == 'completed');
  }

  allow update: if request.auth != null && 
    // Đảm bảo chỉ thay đổi status theo đúng máy trạng thái
    isValidTransition(resource.data.status, request.resource.data.status) &&
    // Và đảm bảo người sửa phải là người liên quan (khách hoặc thợ)
    (request.auth.uid == resource.data.customerId || request.auth.uid == resource.data.technicianId);
}
