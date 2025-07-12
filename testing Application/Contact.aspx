<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="testing_Application.Contact" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Register User with AJAX</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <form id="form1" runat="server" class="container mt-5" style="max-width: 700px;">
        <h2 class="mb-4">Employee Form</h2>

        <div class="mb-3">
            <label for="txtFullName" class="form-label">Full Name</label>
            <input type="text" id="txtFullName" class="form-control" placeholder="Enter full name" required />
        </div>

        <div class="mb-3">
            <label for="txtEmail" class="form-label">Email</label>
            <input type="email" id="txtEmail" class="form-control" placeholder="Enter email" required />
        </div>

        <div class="mb-3">
            <label for="txtAddress" class="form-label">Address</label>
            <textarea id="txtAddress" class="form-control" rows="3" placeholder="Enter address"></textarea>
        </div>

        <button type="button" id="btnSubmit" class="btn btn-primary">Save</button>

        <div id="resultMessage" class="mt-3"></div>
    </form>

    <div class="container mt-5">
        <h2 class="mb-4">Employee Details</h2>

        <table class="table table-striped table-hover align-middle" id="userTable">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Address</th>
                    <th style="width: 130px;">Actions</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="editModalLabel">Edit User</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <input type="hidden" id="Recordid" />
            <div class="mb-3">
              <label for="txtFullName2" class="form-label">Full Name</label>
              <input type="text" id="txtFullName2" class="form-control" />
            </div>
            <div class="mb-3">
              <label for="txtEmail2" class="form-label">Email</label>
              <input type="email" id="txtEmail2" class="form-control" />
            </div>
            <div class="mb-3">
              <label for="txtAddress2" class="form-label">Address</label>
              <textarea id="txtAddress2" class="form-control" rows="3"></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" id="btnSaveEdit" class="btn btn-success">Save Changes</button>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        $(document).ready(function () {
            loadUsers();

            // Save new user
            $("#btnSubmit").click(function () {
                const userData = {
                    fullName: $("#txtFullName").val(),
                    email: $("#txtEmail").val(),
                    address: $("#txtAddress").val()
                };

                $.ajax({
                    type: "POST",
                    url: "Contact.aspx/SaveUser",
                    data: JSON.stringify(userData),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        $("#resultMessage").removeClass().addClass('text-success').text(response.d);
                        clearForm();
                        loadUsers();
                    },
                    error: function (xhr) {
                        $("#resultMessage").removeClass().addClass('text-danger').text("Error: " + xhr.responseText);
                    }
                });
            });

            // Save edited user
            $("#btnSaveEdit").click(function () {
                const data = {
                    id: $("#Recordid").val(),
                    fullName: $("#txtFullName2").val(),
                    email: $("#txtEmail2").val(),
                    address: $("#txtAddress2").val()
                };

                $.ajax({
                    type: "POST",
                    url: "Contact.aspx/UpdateUser",
                    data: JSON.stringify(data),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        $("#resultMessage").removeClass().addClass('text-success').text(response.d);
                        var editModal = bootstrap.Modal.getInstance(document.getElementById('editModal'));
                        editModal.hide();
                        loadUsers();
                    },
                    error: function (xhr) {
                        $("#resultMessage").removeClass().addClass('text-danger').text("Error: " + xhr.responseText);
                    }
                });
            });

            // Delete user - delegate because buttons loaded dynamically
            $("#userTable").on("click", ".btn-delete", function () {
                const id = $(this).data("id");
                if (!confirm("Are you sure you want to delete this user?")) return;

                $.ajax({
                    type: "POST",
                    url: "Contact.aspx/DeleteRecord",
                    data: JSON.stringify({ id: id }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        $("#resultMessage").removeClass().addClass('text-success').text(response.d);
                        loadUsers();
                    },
                    error: function (xhr) {
                        $("#resultMessage").removeClass().addClass('text-danger').text("Error: " + xhr.responseText);
                    }
                });
            });

        });

        function loadUsers() {
            $.ajax({
                type: "POST",
                url: "Contact.aspx/GetUserRecord",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const users = response.d;
                    let rows = "";
                    $.each(users, function (index, user) {
                        rows += `<tr>
                            <td>${index + 1}</td>
                            <td>${user.Name}</td>
                            <td>${user.Email}</td>
                            <td>${user.Address}</td>
                            <td>
                                <button class="btn btn-sm btn-warning me-2 btn-edit" onclick="editUser('${user.Id}')">Edit</button>
                                <button class="btn btn-sm btn-danger btn-delete" data-id="${user.Id}">Delete</button>
                            </td>
                        </tr>`;
                    });
                    $("#userTable tbody").html(rows);
                },
                error: function (xhr) {
                    alert("Error loading users: " + xhr.responseText);
                }
            });
        }

        function clearForm() {
            $("#txtFullName").val('');
            $("#txtEmail").val('');
            $("#txtAddress").val('');
            $("#resultMessage").text('');
        }

        function editUser(id) {
            $.ajax({
                type: "POST",
                url: "Contact.aspx/GetbyUserId",
                data: JSON.stringify({ id: id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const user = response.d;
                    $("#Recordid").val(user.Id);
                    $("#txtFullName2").val(user.Name);
                    $("#txtEmail2").val(user.Email);
                    $("#txtAddress2").val(user.Address);
                    new bootstrap.Modal(document.getElementById('editModal')).show();
                },
                error: function (xhr) {
                    alert("Error fetching user details: " + xhr.responseText);
                }
            });
        }
    </script>
</body>
</html>
