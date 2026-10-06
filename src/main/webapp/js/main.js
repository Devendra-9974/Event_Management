// Arya College ClubSphere Client Scripts

document.addEventListener('DOMContentLoaded', function () {
  // Auto-dismiss alerts after 5 seconds
  const alerts = document.querySelectorAll('.alert-dismissible');
  alerts.forEach(function (alert) {
    setTimeout(function () {
      const bsAlert = new bootstrap.Alert(alert);
      bsAlert.close();
    }, 5000);
  });

  // Dynamic Group Participant Fields in Event Registration
  const regTypeIndividual = document.getElementById('regTypeIndividual');
  const regTypeGroup = document.getElementById('regTypeGroup');
  const groupFieldsContainer = document.getElementById('groupRegistrationFields');
  const addParticipantBtn = document.getElementById('addParticipantBtn');
  const participantsList = document.getElementById('participantsList');

  if (regTypeIndividual && regTypeGroup && groupFieldsContainer) {
    function toggleRegistrationType() {
      if (regTypeGroup.checked) {
        groupFieldsContainer.classList.remove('d-none');
      } else {
        groupFieldsContainer.classList.add('d-none');
      }
    }

    regTypeIndividual.addEventListener('change', toggleRegistrationType);
    regTypeGroup.addEventListener('change', toggleRegistrationType);
    toggleRegistrationType();
  }

  if (addParticipantBtn && participantsList) {
    let participantIndex = 2; // Member 1 is team leader
    addParticipantBtn.addEventListener('click', function () {
      const row = document.createElement('div');
      row.className = 'participant-row border rounded-3 p-3 mb-2 bg-light position-relative';
      row.innerHTML = `
        <div class="d-flex justify-content-between align-items-center mb-2">
          <strong class="text-secondary small">Participant #${participantIndex}</strong>
          <button type="button" class="btn btn-sm btn-outline-danger py-0 px-2 remove-participant-btn">&times;</button>
        </div>
        <div class="row g-2">
          <div class="col-md-3">
            <input type="text" name="memberName[]" class="form-control form-control-sm" placeholder="Full Name" required>
          </div>
          <div class="col-md-3">
            <input type="text" name="memberId[]" class="form-control form-control-sm" placeholder="Student ID (Roll No)" required>
          </div>
          <div class="col-md-3">
            <input type="email" name="memberEmail[]" class="form-control form-control-sm" placeholder="Email" required>
          </div>
          <div class="col-md-3">
            <input type="text" name="memberPhone[]" class="form-control form-control-sm" placeholder="Phone Number">
          </div>
        </div>
      `;
      participantsList.appendChild(row);
      participantIndex++;

      // Remove button listener
      row.querySelector('.remove-participant-btn').addEventListener('click', function () {
        row.remove();
      });
    });
  }
});

// Mark single notification as read via AJAX
function markNotificationRead(notifId, el) {
  const pathParts = window.location.pathname.split('/');
  const context = pathParts[1] === 'aryaClgClubSphere' ? '/aryaClgClubSphere' : '';
  const notifUrl = context + '/notifications';

  fetch(notifUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'id=' + encodeURIComponent(notifId)
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      if (el) {
        el.classList.remove('bg-light');
        el.classList.add('opacity-75');
      }
      const badge = document.getElementById('notifBadge');
      if (badge) {
        if (data.unread > 0) {
          badge.innerText = data.unread;
        } else {
          badge.remove();
        }
      }
    }
  })
  .catch(err => console.error(err));
}
