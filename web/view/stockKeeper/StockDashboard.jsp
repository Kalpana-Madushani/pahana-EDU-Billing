<%@page import="model.Book"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Book editBook = (Book) request.getAttribute("editBook");
    int totalBooks = (request.getAttribute("totalBooks") != null) ? (int) request.getAttribute("totalBooks") : 0;
    int totalStock = (request.getAttribute("totalStock") != null) ? (int) request.getAttribute("totalStock") : 0;
    double totalValue = (request.getAttribute("totalValue") != null) ? (double) request.getAttribute("totalValue") : 0.0;
    long uniqueAuthors = request.getAttribute("uniqueAuthors") != null ? (long) request.getAttribute("uniqueAuthors") : 0;
    long uniqueCategories = request.getAttribute("uniqueCategories") != null ? (long) request.getAttribute("uniqueCategories") : 0;
    double averagePrice = request.getAttribute("averagePrice") != null ? (double) request.getAttribute("averagePrice") : 0.0;
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Stock Keeper Panel</title>
        <link rel="icon" href="https://img.icons8.com/color/48/000000/books.png" type="image/png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <style>
            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen,
                    Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
                background-color: #f9fafb;
                color: #111827;
                display: flex;
                height: 100vh;
            }

            html {
                scroll-behavior: smooth;
            }

            .sidebar {
                width: 250px;
                background-color: #ffffff;
                border-right: 1px solid #e5e7eb;
                display: flex;
                flex-direction: column;
                padding: 24px 20px;
                min-width: 250px;
                max-width: 250px;
                flex-shrink: 0;
            }


            .sidebar .logo {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                font-size: 2rem;
                font-weight: bold;
                color: #B595D8;
            }

            .sidebar h2 {
                font-weight: 700;
                font-size: 1.75rem;
                margin-bottom: 40px;
                color: #111827;
                text-align: center;
                letter-spacing: 1px;
            }

            .sidebar a {
                font-weight: 600;
                font-size: 1rem;
                color: #374151;
                padding: 20px 16px;
                margin-bottom: 20px;
                border-radius: 6px;
                text-decoration: none;
                display: block;
                transition: background-color 0.15s ease, color 0.15s ease;
                cursor: pointer;
            }

            .sidebar a:not(.logout):hover,
            .sidebar a.active {
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                color: #374151;
            }

            .sidebar a.logout {
                background-color: #ef4444;
                color: #ffffff;
                font-weight: 700;
                text-align: left;
                border-radius: 6px;
                padding: 20px 16px;
                transition: background-color 0.15s ease;
            }
            .sidebar a.logout:hover {
                background-color: #b91c1c;
            }

            /* Main Content */
            .main {
                flex-grow: 1;
                background-color: #ffffff;
                padding: 40px 50px;
                overflow-y: auto;
                border-radius: 0 8px 8px 0;
                box-shadow: inset 0 0 10px rgba(0,0,0,0.05);
            }

            h2.page-title {
                font-weight: 800;
                font-size: 2.25rem;
                margin-bottom: 32px;
                border-left: 4px solid #E8D5F2;
                padding-left: 16px;
                color: #1f2937;
            }

            h1 {
                margin-bottom: 20px;
            }

            h3 {
                font-weight: 600;
                font-size: 1.25rem;
                margin-bottom: 24px;
                color: #374151;
            }

            /* Modal styling */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0,0,0,0.4);
            }
            .modal-content {
                background-color: #fff;
                margin: 10% auto;
                padding: 32px 36px;
                border-radius: 12px;
                width: 500px;
                box-shadow: 0 25px 50px rgba(0,0,0,0.25);
                position: relative;
            }
            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
                transition: color 0.3s ease;
            }
            .close:hover {
                color: #000;
            }

            /* Support Message Pop-up */
            .support-message {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6); /* Slightly darker overlay for better contrast */
                z-index: 1000;
                align-items: center;
                justify-content: center;
                animation: fadeIn 0.3s ease-in-out;
            }

            .support-message-content {
                background: #ffffff;
                border-radius: 16px;
                padding: 24px;
                max-width: 450px;
                width: 90%;
                box-shadow: 0 8px 24px rgba(181, 149, 216, 0.2);
                text-align: center;
            }

            .support-message-header {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 16px;
                padding-bottom: 12px;
                border-bottom: 2px solid #E8D5F2;
            }

            .support-icon {
                font-size: 1.8rem;
                padding: 8px;
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0);
                border-radius: 12px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .support-message-content h3 {
                margin: 0;
                color: #374151;
                font-size: 1.5rem;
                font-weight: 700;
            }

            .support-message-content p {
                color: #6b7280;
                font-size: 1rem;
                line-height: 1.8;
                margin: 0 0 20px 0;
            }

            .support-message-content a {
                color: #B595D8;
                text-decoration: none;
                font-weight: 600;
            }

            .support-message-content a:hover {
                text-decoration: underline;
            }

            .support-message-actions {
                display: flex;
                justify-content: center;
                gap: 12px;
            }

            .support-message-content button {
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                border: none;
                color: #ffffff;
                padding: 12px 28px;
                border-radius: 8px;
                font-weight: 700;
                font-size: 1rem;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .support-message-content button:hover {
                background: linear-gradient(135deg, #D1BAE8, #B595D8, #A584C7);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(181, 149, 216, 0.3);
            }

            /* Error message */
            .error {
                background-color: #fee2e2;
                border-left: 4px solid #dc2626;
                color: #b91c1c;
                padding: 14px 20px;
                margin-bottom: 30px;
                font-weight: 600;
                border-radius: 6px;
                user-select: none;
                display: none;
            }

            .error.show {
                display: block;
            }

            /* Dashboard Container */
            .dashboard-wrapper {
                background-color: #f3f4f6;
                border-radius: 8px;
                padding: 32px 36px;
                margin-bottom: 32px;
                box-shadow: none;
            }

            /* Enhanced Dashboard Sections */
            .dashboard-section {
                margin-bottom: 40px;
                background: #ffffff;
                border-radius: 16px;
                padding: 32px;
                box-shadow: 0 8px 24px rgba(181, 149, 216, 0.08);
                border: 1px solid rgba(232, 213, 242, 0.3);
                transition: all 0.3s ease;
            }

            .dashboard-section:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 32px rgba(181, 149, 216, 0.12);
            }

            /* Updated Section Title Styling */
            .section-title {
                font-size: 1.5rem !important;
                font-weight: 700;
                color: #374151 !important;
                margin-bottom: 24px !important;
                display: flex;
                align-items: center;
                gap: 12px;
                padding-bottom: 16px;
                border-bottom: 2px solid #E8D5F2 !important;
                border-left: none !important;
                padding-left: 0 !important;
            }

            .section-icon {
                font-size: 1.8rem;
                padding: 8px;
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0);
                border-radius: 12px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            /* Enhanced Low Stock Table */
            .low-stock-table {
                width: 100%;
                border-collapse: collapse;
                background: #ffffff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 16px rgba(181, 149, 216, 0.1);
            }

            .low-stock-table thead {
                background: linear-gradient(135deg, #B595D8, #9575CD);
                color: white;
            }

            .low-stock-table th {
                padding: 16px 20px;
                text-align: left;
                font-weight: 600;
                font-size: 0.95rem;
                letter-spacing: 0.5px;
            }

            .low-stock-table td {
                padding: 16px 20px;
                border-bottom: 1px solid #E8D5F2;
                transition: background-color 0.2s ease;
            }

            .low-stock-table tbody tr:hover {
                background: linear-gradient(90deg, rgba(232, 213, 242, 0.1), rgba(255, 255, 255, 0.1));
            }

            .low-stock-table tbody tr:last-child td {
                border-bottom: none;
            }

            /* Stock Level Indicators */
            .stock-indicator {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.85rem;
            }

            .stock-critical {
                background: linear-gradient(135deg, #fee2e2, #fecaca);
                color: #dc2626;
                border: 1px solid #fca5a5;
            }

            .stock-low {
                background: linear-gradient(135deg, #fef3c7, #fde68a);
                color: #d97706;
                border: 1px solid #fbbf24;
            }

            /* Book Title Styling in Table */
            .book-title {
                font-weight: 600;
                color: #1f2937;
                margin-bottom: 4px;
            }

            .book-meta {
                font-size: 0.85rem;
                color: #6b7280;
            }

            /* Enhanced Recent Books Container */
            .recent-books-container {
                background: linear-gradient(135deg, rgba(232, 213, 242, 0.05), rgba(255, 255, 255, 0.8));
                border-radius: 12px;
                padding: 24px;
                border: 1px solid rgba(232, 213, 242, 0.3);
            }

            .recent-books-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
                gap: 16px;
            }

            .recent-book-card {
                background: #ffffff;
                border-radius: 12px;
                padding: 20px;
                border-left: 4px solid #B595D8;
                box-shadow: 0 4px 12px rgba(181, 149, 216, 0.08);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .recent-book-card:hover {
                transform: translateX(4px);
                box-shadow: 0 6px 20px rgba(181, 149, 216, 0.15);
            }

            .recent-book-card::before {
                content: '';
                position: absolute;
                top: 0;
                right: 0;
                width: 60px;
                height: 60px;
                background: linear-gradient(135deg, rgba(232, 213, 242, 0.1), rgba(200, 168, 224, 0.1));
                border-radius: 0 12px 0 60px;
            }

            .book-card-header {
                display: flex;
                align-items: flex-start;
                gap: 12px;
                margin-bottom: 12px;
            }

            .book-icon {
                font-size: 1.5rem;
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0);
                padding: 8px;
                border-radius: 8px;
                flex-shrink: 0;
            }

            .book-info h4 {
                margin: 0 0 4px 0;
                font-size: 1.1rem;
                font-weight: 600;
                color: #1f2937;
                line-height: 1.3;
            }

            .book-author {
                font-size: 0.9rem;
                color: #6b7280;
                font-style: italic;
                margin-bottom: 8px;
            }

            .book-details {
                display: flex;
                gap: 16px;
                font-size: 0.85rem;
                color: #6b7280;
                flex-wrap: wrap;
            }

            .book-detail {
                display: flex;
                align-items: center;
                gap: 4px;
            }

            /* Enhanced Empty State - Override existing */
            .dashboard-empty {
                text-align: center !important;
                padding: 48px 24px !important;
                background: linear-gradient(135deg, rgba(232, 213, 242, 0.05), rgba(255, 255, 255, 0.8)) !important;
                border: 2px dashed #E8D5F2 !important;
                border-radius: 16px !important;
                color: #6b7280 !important;
            }

            .empty-icon {
                font-size: 4rem;
                margin-bottom: 16px;
                opacity: 0.6;
                display: block;
            }

            .empty-message {
                font-size: 1.1rem;
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                display: block;
            }

            .empty-submessage {
                font-size: 0.9rem;
                color: #6b7280;
                display: block;
            }

            /* Action Buttons */
            .section-actions {
                margin-top: 24px;
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
            }

            .action-button {
                padding: 8px 16px;
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                color: #374151;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 600;
                font-size: 0.9rem;
                transition: all 0.2s ease;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .action-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(181, 149, 216, 0.3);
                text-decoration: none;
                color: #374151;
            }


            /* Title */
            .dashboard-title {
                font-size: 2rem;
                margin-bottom: 1.5rem;
                font-weight: bold;
                color: #2c3e50;
            }

            /* Cards Layout */
            .dashboard-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
                margin-bottom: 3rem;
            }

            .dashboard-card {
                background: #ffffff;
                border-radius: 16px;
                box-shadow: 0 8px 24px rgba(0,0,0,0.05);
                padding: 1.5rem;
                display: flex;
                align-items: center;
                gap: 1rem;
                transition: all 0.3s ease;
            }

            .dashboard-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 12px 28px rgba(0,0,0,0.08);
            }

            .card-icon {
                font-size: 2rem;
                color: #0984e3;
                background: #e8f0fe;
                padding: 0.75rem;
                border-radius: 12px;
            }

            .card-title {
                font-size: 0.95rem;
                color: #636e72;
                margin-bottom: 0.3rem;
            }

            .card-value {
                font-size: 0.9rem;
                color: #2d3436;
                font-weight: 600;
            }

            /* Table */
            .dashboard-table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }

            .dashboard-table thead {
                background-color: #0984e3;
                color: white;
            }

            .dashboard-table th, .dashboard-table td {
                padding: 1rem;
                text-align: left;
            }

            .dashboard-table tbody tr {
                border-top: 1px solid #eee;
            }

            .dashboard-table tbody tr:hover {
                background-color: #f0f4f8;
            }

            tbody tr:nth-child(odd) {
                background-color: #ffffff;
            }
            tbody tr:nth-child(even) {
                background-color: #f9fafb;
            }
            tbody tr:hover {
                background-color: #e0e7ff;
                cursor: pointer;
            }

            /* Empty Messages */
            .dashboard-empty {
                padding: 1rem;
                background: #dfe6e9;
                color: #2d3436;
                border-left: 4px solid #636e72;
                border-radius: 8px;
                margin-bottom: 2rem;
            }

            /* Recently Added List */
            .recent-books-list {
                list-style: none;
                padding: 0;
                background: #fff;
                border-radius: 12px;
                padding: 1rem 1.5rem;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }

            .recent-books-list li {
                padding: 0.75rem 0;
                border-bottom: 1px solid #eee;
            }

            .recent-books-list li:last-child {
                border-bottom: none;
            }

            .recent-book-icon {
                margin-right: 8px;
                font-size: 1.2rem;
            }


            form label {
                font-weight: 600;
                margin-bottom: 8px;
                display: block;
                color: #4b5563;
                font-size: 14px;
            }

            form input[type="text"],
            form input[type="email"],
            form input[type="number"],
            form input[type="file"],
            form select {
                width: 100%;
                padding: 10px 14px;
                margin-bottom: 20px;
                border: 1px solid #E8D5F2;
                border-radius: 8px;
                font-size: 15px;
                color: #374151;
                background-color: #ffffff;
                transition: border-color 0.2s ease;
            }
            form input[type="text"]:focus,
            form input[type="email"]:focus,
            form input[type="number"]:focus,
            form input[type="file"]:focus,
            form select:focus {
                border-color: #B595D8;
                outline: none;
                background-color: #eff6ff;
            }

            form button {
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                border: none;
                color: #ffffff;
                padding: 12px 28px;
                border-radius: 6px;
                font-weight: 700;
                font-size: 1rem;
                cursor: pointer;
                transition: background-color 0.2s ease;
            }
            form button:hover {
                background-color: #4f46e5;
            }

            form select {
                width: 100%;
                padding: 10px 14px;
                margin-bottom: 20px;
                border: 1px solid #E8D5F2;
                border-radius: 8px;
                font-size: 15px;
                color: #374151;
                background-color: #ffffff;
                transition: border-color 0.2s ease;
            }

            form select:focus {
                border-color: #B595D8;
                outline: none;
                background-color: #eff6ff;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }

            th, td {
                padding: 14px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }

            th {
                background-color: #f9fafb;
                color: black;
            }

            td img {
                width: 70px;
                height: auto;
                border-radius: 4px;
            }

            .action-links a {
                margin-right: 10px;
                text-decoration: none;
                color: #2c3e50;
                font-weight: bold;
            }

            .action-links a:hover {
                text-decoration: underline;
            }

            .section {
                display: none;
                transition: opacity 0.3s ease;
            }

            .section.active {
                display: block;
            }

            /* Action buttons */
            .action-btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 8px 16px;
                border: none;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                margin-right: 8px;
            }
            .action-btn.edit {
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                color: #ffffff;
                box-shadow: 0 2px 4px rgba(181, 149, 216, 0.3);
            }
            .action-btn.edit:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(181, 149, 216, 0.4);
                background: linear-gradient(135deg, #D1BAE8, #B595D8, #A584C7);
            }
            .action-btn.delete {
                background: #ef4444;
                color: #ffffff;
                box-shadow: 0 2px 4px rgba(239, 68, 68, 0.3);
            }
            .action-btn.delete:hover {
                background: #dc2626;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
            }

            .delete-btn {
                background-color: #f44336;
            }

            .delete-btn:hover {
                background-color: #d32f2f;
                text-decoration: none;
                transform: scale(1.05);
            }

            .action-btn i {
                margin-right: 5px;
            }

            /* Help Section Styles */
            .help-wrapper {
                background-color: #f3f4f6;
                border-radius: 8px;
                padding: 32px 36px;
                margin-bottom: 32px;
                box-shadow: none;
            }

            .help-container {
                max-width: 1000px;
                margin: 0 auto;
            }

            .help-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 24px;
                margin-bottom: 32px;
            }

            .help-card {
                background: #ffffff;
                border-radius: 16px;
                padding: 24px;
                box-shadow: 0 4px 16px rgba(181, 149, 216, 0.08);
                border: 1px solid rgba(232, 213, 242, 0.3);
                transition: all 0.3s ease;
            }

            .help-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 24px rgba(181, 149, 216, 0.12);
            }

            .help-card-header {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 16px;
                padding-bottom: 12px;
                border-bottom: 2px solid #E8D5F2;
            }

            .help-icon {
                font-size: 2rem;
                padding: 12px;
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0);
                border-radius: 12px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .help-card h4 {
                font-size: 1.25rem;
                font-weight: 700;
                color: #374151;
                margin: 0;
            }

            .help-card p {
                color: #6b7280;
                line-height: 1.6;
                margin-bottom: 12px;
            }

            .help-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .help-list li {
                padding: 8px 0;
                padding-left: 24px;
                position: relative;
                color: #374151;
                line-height: 1.5;
            }

            .help-list li::before {
                content: "→";
                position: absolute;
                left: 0;
                color: #B595D8;
                font-weight: bold;
            }

            .help-tip {
                background: linear-gradient(135deg, rgba(232, 213, 242, 0.1), rgba(255, 255, 255, 0.8));
                border-left: 4px solid #B595D8;
                border-radius: 8px;
                padding: 16px;
                margin: 16px 0;
            }

            .help-tip-title {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .help-tip-content {
                color: #6b7280;
                font-size: 0.9rem;
                line-height: 1.5;
            }

            .shortcut-key {
                background: #E8D5F2;
                color: #374151;
                padding: 2px 8px;
                border-radius: 4px;
                font-size: 0.8rem;
                font-weight: 600;
                margin: 0 2px;
            }

            .feature-highlight {
                background: linear-gradient(135deg, rgba(232, 213, 242, 0.05), rgba(255, 255, 255, 0.8));
                border: 1px solid rgba(232, 213, 242, 0.3);
                border-radius: 12px;
                padding: 20px;
                margin: 16px 0;
            }

            .faq-section {
                margin-top: 32px;
            }

            .faq-item {
                background: #ffffff;
                border-radius: 12px;
                margin-bottom: 12px;
                box-shadow: 0 2px 8px rgba(181, 149, 216, 0.05);
                border: 1px solid rgba(232, 213, 242, 0.2);
                overflow: hidden;
            }

            .faq-question {
                padding: 16px 20px;
                background: linear-gradient(135deg, #E8D5F2, rgba(200, 168, 224, 0.3));
                cursor: pointer;
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-weight: 600;
                color: #374151;
                transition: all 0.3s ease;
            }

            .faq-question:hover {
                background: linear-gradient(135deg, #D1BAE8, rgba(181, 149, 216, 0.3));
            }

            .faq-answer {
                padding: 16px 20px;
                color: #6b7280;
                line-height: 1.6;
                border-top: 1px solid rgba(232, 213, 242, 0.3);
                background: #ffffff;
            }

            .faq-toggle {
                font-size: 1.2rem;
                transition: transform 0.3s ease;
            }

            .faq-item.active .faq-toggle {
                transform: rotate(180deg);
            }

            .contact-support {
                background: linear-gradient(135deg, #B595D8, #9575CD);
                color: white;
                border-radius: 16px;
                padding: 24px;
                text-align: center;
                margin-top: 32px;
            }

            .contact-support h4 {
                margin: 0 0 12px 0;
                font-size: 1.5rem;
                font-weight: 700;
            }

            .contact-support p {
                margin: 0 0 16px 0;
                opacity: 0.9;
            }

            .contact-btn {
                background: rgba(255, 255, 255, 0.2);
                color: white;
                border: 2px solid rgba(255, 255, 255, 0.3);
                padding: 12px 24px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .contact-btn:hover {
                background: rgba(255, 255, 255, 0.3);
                border-color: rgba(255, 255, 255, 0.5);
                transform: translateY(-2px);
            }

            /* Animation for smooth appearance */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @media screen and (max-width: 768px) {
                .dashboard-cards {
                    flex-direction: column;
                }

                table th, table td {
                    padding: 12px 10px;
                    font-size: 13px;
                }

                .help-grid {
                    grid-template-columns: 1fr;
                }

                .help-card {
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <aside class="sidebar">
            <h2 class="logo">🏠 PAHANA Edu</h2>
            <nav>
                <a href="#" class="active" data-target="dashboard">📊 Dashboard</a>
                <a href="#" data-target="bookForm">➕ Add Book</a>
                <a href="#" data-target="manageBooks">📘 Manage Books</a>
                <a href="#" data-target="help">❓ Help & Guide</a>
                <a href="login.jsp" class="logout">🔓 Logout</a>
            </nav>
        </aside>

        <main class="main">
            <h2 class="page-title">Stock Keeper Panel</h2>

            <!--    Dashboard section -->
            <section id="dashboard" class="section active dashboard-wrapper">
                <h3>1. Dashboard</h3>
                <!-- Top Stats Cards -->
                <div class="dashboard-grid">
                    <div class="dashboard-card">
                        <div class="card-icon">📚</div>
                        <div>
                            <p class="card-title">Total Books</p>
                            <h2 class="card-value"><%= totalBooks%></h2>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-icon">📦</div>
                        <div>
                            <p class="card-title">Total Stock</p>
                            <h2 class="card-value"><%= totalStock%></h2>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-icon">💰</div>
                        <div>
                            <p class="card-title">Inventory Value</p>
                            <h2 class="card-value">Rs. <%= String.format("%.2f", totalValue)%></h2>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-icon">🖊️</div>
                        <div>
                            <p class="card-title">Unique Authors</p>
                            <h2 class="card-value"><%= uniqueAuthors%></h2>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-icon">🏷️</div>
                        <div>
                            <p class="card-title">Categories</p>
                            <h2 class="card-value"><%= uniqueCategories%></h2>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-icon">📈</div>
                        <div>
                            <p class="card-title">Average Price</p>
                            <h2 class="card-value">Rs. <%= String.format("%.2f", averagePrice)%></h2>
                        </div>
                    </div>
                </div>

                <!-- Low Stock Books Section -->
                <div class="dashboard-section">
                    <%
                        List<Book> lowStockBooks = (List<Book>) request.getAttribute("lowStockBooks");
                        if (lowStockBooks != null && !lowStockBooks.isEmpty()) {
                    %>
                    <h2 class="section-title">
                        <span class="section-icon">⚠️</span>
                        Low Stock Alert
                        <span style="font-size: 0.8rem; font-weight: 400; color: #6b7280; margin-left: auto;">(Stock < 5)</span>
                    </h2>
                    <table class="low-stock-table">
                        <thead>
                            <tr>
                                <th>Book Details</th>
                                <th>Current Stock</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Book b : lowStockBooks) {%>
                            <tr>
                                <td>
                                    <div class="book-title"><%= b.getTitle()%></div>
                                    <div class="book-meta"><%= b.getAuthor()%> • <%= b.getCategory()%></div>
                                </td>
                                <td><%= b.getStock()%></td>
                                <td>
                                    <span class="stock-indicator stock-critical">🔴 Critical</span>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <div class="dashboard-section" style="margin-top: 20px;">
                        <h2 class="section-title">
                            <span class="section-icon">🎉</span>
                            Well-Stocked Books
                        </h2>

                        <div class="dashboard-empty">
                            <div class="empty-icon">🎉</div>
                            <div class="empty-message">All books are well-stocked!</div>
                            <div class="empty-submessage">No books currently have stock levels below 5 units.</div>
                        </div>
                    </div>
                    <% }%>
                </div>

                <!-- Recent Books Section -->
                <div class="dashboard-section">
                    <h2 class="section-title">
                        <span class="section-icon">🆕</span>
                        Recently Added Books
                        <span style="font-size: 0.8rem; font-weight: 400; color: #6b7280; margin-left: auto;">Latest additions</span>
                    </h2>
                    <%
                        List<Book> recentBooks = (List<Book>) request.getAttribute("recentBooks");
                        if (recentBooks != null && !recentBooks.isEmpty()) {
                    %>
                    <div class="recent-books-container">
                        <div class="recent-books-grid">
                            <% for (Book b : recentBooks) {%>
                            <div class="recent-book-card">
                                <div class="book-card-header">
                                    <!--                                    <div class="book-icon">📘</div>-->
                                    <img src="<%= b.getImageUrl()%>" alt="Book Cover" style="width:50px; height:70px;" />
                                    <div class="book-info">
                                        <h4><%= b.getTitle()%></h4>
                                        <div class="book-author"><%= b.getAuthor()%></div>
                                    </div>
                                </div>
                                <div class="book-details">
                                    <div class="book-detail">
                                        <span>📚</span>
                                        <span><%= b.getCategory()%></span>
                                    </div>
                                    <div class="book-detail">
                                        <span>📦</span>
                                        <span><%= b.getStock()%> in stock</span>
                                    </div>
                                    <div class="book-detail">
                                        <span>💰</span>
                                        <span>Rs. <%= b.getPrice()%></span>
                                    </div>
                                </div>
                            </div>
                            <% }%>
                        </div>
                    </div>
                    <% } else { %>
                    <p class="dashboard-empty">📭 No recent books found.</p>
                    <% }%>
                </div>
            </section>

            <!--Add book section-->
            <section id="bookForm" class="section dashboard-wrapper" style="display:none;">
                <h3>2. Add New Book</h3>
                <form action="${pageContext.request.contextPath}/books" method="post">
                    <input type="hidden" name="action" value="AddBookFromStock"/>
                    <input type="hidden" id="userId" name="id" />
                    <label for="book_title">Book Title *</label>
                    <input type="text" name="title" placeholder="e.g., The Great Gatsby" required />
                    <label for="author">Author *</label>
                    <input type="text" name="author" placeholder="e.g., F. Scott Fitzgerald" required />
                    <label for="category">Category *</label>
                    <input type="text" name="category" placeholder="Category" required />
                    <label for="stock_quantity">Stock Quantity *</label>
                    <input type="number" name="stock" placeholder="e.g., 25" required />
                    <label for="publisher">Publisher *</label>
                    <input type="text" name="publisher" placeholder="e.g., Penguin Books" required />
                    <label for="publication_year">Publication Year *</label>
                    <input type="number" name="year" placeholder="e.g., 2024" required />
                    <label for="price">Price *</label>
                    <input type="number" step="0.01" name="price" placeholder="e.g., 1250.00" required />
                    <label for="image">Book Cover Image *</label>
                    <input type="text" id="bookURL" name="bookURL" required />

                    <button type="submit">Add Book</button>
                </form>
            </section>

            <!--        Manage book section-->

            <section id="manageBooks" class="section dashboard-wrapper" style="display:none;">
                <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 20px;">
                    <h3>3. Manage Books</h3>
                    <div style="position: relative; min-width: 400px;">
                        <input 
                            type="text" 
                            id="bookSearch" 
                            placeholder="Search books by title or author..." 
                            oninput="filterBooks()"
                            style="width: 100%; padding: 12px 40px 12px 14px; border-radius: 8px; border: 1px solid #E8D5F2; font-size: 16px; transition: border-color 0.3s ease, outline 0.3s ease; outline: none;"
                            onfocus="this.style.borderColor = '#E8D5F2';"
                            onblur="this.style.borderColor = '#E8D5F2';"
                            />
                    </div>
                </div>

                <%
                    List<Book> books = (List<Book>) request.getAttribute("books");
                    if (books != null && !books.isEmpty()) {
                %>
                <table id="booksTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Category</th>
                            <th>Stock</th>
                            <th>Publisher</th>
                            <th>Year</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Book b : books) {%>
                        <tr data-book-id="<%= b.getId()%>"
                            data-title="<%= b.getTitle()%>"
                            data-author="<%= b.getAuthor()%>"
                            data-category="<%= b.getCategory()%>"
                            data-stock="<%= b.getStock()%>"
                            data-publisher="<%= b.getPublisher()%>"
                            data-year="<%= b.getYear()%>"
                            data-price="<%= b.getPrice()%>"
                            data-url="<%= b.getImageUrl()%>"
                            >
                            <td><%= b.getId()%></td>
                            <td><%= b.getTitle()%></td>
                            <td><%= b.getAuthor()%></td>
                            <td><%= b.getCategory()%></td>
                            <td><%= b.getStock()%></td>
                            <td><%= b.getPublisher()%></td>
                            <td><%= b.getYear()%></td>
                            <td>Rs.<%= b.getPrice()%></td>
                            <td>
                                <button class="action-btn edit" onclick="openEditBookModal(this)">
                                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                    </svg>
                                    Edit
                                </button>
                                <button class="action-btn delete" onclick="confirmDelete('book', <%= b.getId()%>)">
                                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                                    <path d="M3 6h18"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/>
                                    </svg>
                                    Delete
                                </button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p style="color:#6b7280; font-style: italic;">No books found.</p>
                <% }%>
            </section>

            <!--        Help section-->
            <section id="help" class="section dashboard-wrapper" style="display:none;">
                <div class="help-container">
                    <h3>4. Help & User Guide</h3>

                    <!-- Quick Start Cards -->
                    <div class="help-grid">
                        <div class="help-card">
                            <div class="help-card-header">
                                <div class="help-icon">📊</div>
                                <h4>Dashboard Overview</h4>
                            </div>
                            <p>Your central hub for monitoring bookstore inventory and performance.</p>
                            <ul class="help-list">
                                <li>View key metrics: total books, stock, and inventory value</li>
                                <li>Monitor low stock alerts for books with less than 5 units</li>
                                <li>Check recently added books</li>
                                <li>Track unique authors and categories</li>
                            </ul>
                            <div class="help-tip">
                                <div class="help-tip-title">💡 Pro Tip</div>
                                <div class="help-tip-content">Check the dashboard daily to stay on top of low stock alerts and avoid stockouts.</div>
                            </div>
                        </div>

                        <div class="help-card">
                            <div class="help-card-header">
                                <div class="help-icon">➕</div>
                                <h4>Adding Books</h4>
                            </div>
                            <p>Easy steps to add new books to your inventory.</p>
                            <ul class="help-list">
                                <li>Fill in all required fields marked with (*)</li>
                                <li>Use descriptive titles and accurate author names</li>
                                <li>Set appropriate stock quantities</li>
                                <li>Add book cover image URL for better presentation</li>
                            </ul>
                            <div class="help-tip">
                                <div class="help-tip-title">⚡ Quick Tip</div>
                                <div class="help-tip-content">Use consistent category naming (e.g., "Fiction", "Non-Fiction") to maintain organization.</div>
                            </div>
                        </div>

                        <div class="help-card">
                            <div class="help-card-header">
                                <div class="help-icon">📘</div>
                                <h4>Managing Books</h4>
                            </div>
                            <p>Efficiently organize and update your book inventory.</p>
                            <ul class="help-list">
                                <li>Search books by title or author using the search bar</li>
                                <li>Edit book details by clicking the Edit button</li>
                                <li>Delete books with confirmation to prevent accidents</li>
                                <li>View all book information in the organized table</li>
                            </ul>
                            <div class="help-tip">
                                <div class="help-tip-title">🔍 Search Tip</div>
                                <div class="help-tip-content">Use partial names in search - typing "Harry" will find "Harry Potter" books.</div>
                            </div>
                        </div>

                        <div class="help-card">
                            <div class="help-card-header">
                                <div class="help-icon">🛡️</div>
                                <h4>Best Practices</h4>
                            </div>
                            <p>Follow these guidelines for optimal inventory management.</p>
                            <ul class="help-list">
                                <li>Update stock levels regularly after sales or restocking</li>
                                <li>Use consistent pricing format (e.g., 1250.00)</li>
                                <li>Keep book information accurate and up-to-date</li>
                                <li>Monitor low stock alerts to prevent stockouts</li>
                            </ul>
                            <div class="help-tip">
                                <div class="help-tip-title">📈 Business Tip</div>
                                <div class="help-tip-content">Set reorder points based on your sales velocity to maintain optimal stock levels.</div>
                            </div>
                        </div>
                    </div>

                    <!-- Feature Highlights -->
                    <div class="feature-highlight">
                        <h4 style="color: #374151; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                            <span>🌟</span> Key Features
                        </h4>
                        <div class="help-grid" style="margin-bottom: 0;">
                            <div style="padding: 12px;">
                                <strong>Real-time Analytics</strong>
                                <p style="margin: 8px 0 0 0; color: #6b7280;">Monitor your inventory metrics with live updates on stock levels and values.</p>
                            </div>
                            <div style="padding: 12px;">
                                <strong>Smart Alerts</strong>
                                <p style="margin: 8px 0 0 0; color: #6b7280;">Automatic low stock notifications help prevent stockouts and lost sales.</p>
                            </div>
                            <div style="padding: 12px;">
                                <strong>Quick Search</strong>
                                <p style="margin: 8px 0 0 0; color: #6b7280;">Find books instantly with our powerful search functionality.</p>
                            </div>
                        </div>
                    </div>

                    <!-- FAQ Section -->
                    <div class="faq-section">
                        <h3 style="color: #374151; margin-bottom: 24px; display: flex; align-items: center; gap: 12px;">
                            <span style="font-size: 1.5rem;">❓</span>
                            Frequently Asked Questions
                        </h3>

                        <div class="faq-item">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <span>How do I update stock quantities after a sale?</span>
                                <span class="faq-toggle">▼</span>
                            </div>
                            <div class="faq-answer" style="display: none;">
                                Go to "Manage Books", find the book you sold, click "Edit", and update the stock quantity. The system will automatically recalculate your total inventory value.
                            </div>
                        </div>

                        <div class="faq-item">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <span>What happens when a book's stock goes below 5?</span>
                                <span class="faq-toggle">▼</span>
                            </div>
                            <div class="faq-answer" style="display: none;">
                                The book automatically appears in the "Low Stock Alert" section on your dashboard with a critical status indicator. This helps you reorder before running out of stock.
                            </div>
                        </div>

                        <div class="faq-item">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <span>Can I bulk import books from a spreadsheet?</span>
                                <span class="faq-toggle">▼</span>
                            </div>
                            <div class="faq-answer" style="display: none;">
                                Currently, books must be added individually through the "Add Book" form. However, you can speed up the process by keeping consistent formatting and using copy-paste for similar information.
                            </div>
                        </div>

                        <div class="faq-item">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <span>How is the inventory value calculated?</span>
                                <span class="faq-toggle">▼</span>
                            </div>
                            <div class="faq-answer" style="display: none;">
                                Inventory value is calculated by multiplying each book's price by its current stock quantity, then summing all books. This gives you the total retail value of your current inventory.
                            </div>
                        </div>

                        <div class="faq-item">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <span>What should I do if I accidentally delete a book?</span>
                                <span class="faq-toggle">▼</span>
                            </div>
                            <div class="faq-answer" style="display: none;">
                                Unfortunately, deleted books cannot be recovered automatically. You'll need to re-add the book using the "Add Book" form. Always double-check before confirming deletions.
                            </div>
                        </div>

                        <div class="faq-item">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <span>Why are some recently added books not showing?</span>
                                <span class="faq-toggle">▼</span>
                            </div>
                            <div class="faq-answer" style="display: none;">
                                The "Recently Added Books" section shows the most recent additions. If you have many books, older entries may not appear. You can always find all books in the "Manage Books" section.
                            </div>
                        </div>
                    </div>

                    <!-- Contact Support -->
                    <div class="contact-support">
                        <h4>Need Additional Help?</h4>
                        <p>Our support team is here to assist you with any questions or technical issues.</p>
                        <a href="#" class="contact-btn" onclick="openSupportMessage(event)">
                            <span>📞</span>
                            Contact Support
                        </a>
                    </div>

                    <!-- Support Message Pop-up -->
                    <div id="supportMessage" class="support-message">
                        <div class="support-message-content">
                            <h3>Contact Support</h3>
                            <p>
                                For assistance, please contact our support team:<br>
                                Email: <a href="mailto:support@pahanabookshop.com">support@pahanabookshop.com</a><br>
                                Phone: +94 11 123 4567<br>
                                Hours: Monday to Friday, 9 AM to 5 PM
                            </p>                            
                            <button onclick="closeSupportMessage()">Close</button>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <!-- Edit Book Modal -->
        <div id="bookModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('bookModal')">&times;</span>
                <h3 id="bookModalTitle">Add Book</h3>
                <div class="error"></div>
                <form id="bookForm" action="<%=request.getContextPath()%>/books", method="POST">
                    <input type="hidden" name="action" value="AddBookFromStock"/>
                    <input type="hidden" id="bookId" name="id" />
                    <label for="bookTitle">Title</label>
                    <input type="text" id="bookTitle" name="title" required />
                    <label for="bookAuthor">Author</label>
                    <input type="text" id="bookAuthor" name="author" required />
                    <label for="bookCategory">Category</label>
                    <input type="text" id="bookCategory" name="category" required />
                    <label for="bookStock">Stock</label>
                    <input type="number" id="bookStock" name="stock" min="0" required />
                    <label for="bookPublisher">Publisher</label>
                    <input type="text" id="bookPublisher" name="publisher" required />
                    <label for="bookYear">Year</label>
                    <input type="number" id="bookYear" name="year" min="1900" max="2100" required />
                    <label for="bookPrice">Price</label>
                    <input type="number" id="bookPrice" name="price" min="0" step="0.01" required />
                    <label for="bookURL">Image URL</label>
                    <input type="text" id="editBookURL" name="editBookURL" required />
                    <button type="submit">Save Book</button>
                </form>
            </div>
        </div>

        <form id="deleteForm" method="post" style="display:none;">
            <input type="hidden" name="action" id="deleteBookAction">
            <input type="hidden" name="id" id="deleteId">
        </form>

        <script>
            const links = document.querySelectorAll('.sidebar nav a[data-target]');
            const sections = document.querySelectorAll('main section');

            function showSection(targetId) {
                let found = false;

                // Remove active class and hide all sections
                links.forEach(link => {
                    if (link.getAttribute('data-target') === targetId) {
                        link.classList.add('active');
                        found = true;
                    } else {
                        link.classList.remove('active');
                    }
                });

                sections.forEach(section => {
                    section.style.display = section.id === targetId ? 'block' : 'none';
                });

                // If targetId not found, fallback to first section
                if (!found && links.length > 0) {
                    const firstId = links[0].getAttribute('data-target');
                    links[0].classList.add('active');
                    sections.forEach(section => {
                        section.style.display = section.id === firstId ? 'block' : 'none';
                    });
                }
            }

            // Click event for sidebar links
            links.forEach(link => {
                link.addEventListener('click', function (e) {
                    e.preventDefault();
                    const targetId = this.getAttribute('data-target');
                    showSection(targetId);

                    // Update URL query parameter without reloading
                    const url = new URL(window.location);
                    url.searchParams.set('activeTab', targetId);
                    window.history.pushState({}, '', url);
                });
            });

            // Handle page load with URL query parameter
            const urlParams = new URLSearchParams(window.location.search);
            const activeTab = urlParams.get('activeTab');
            showSection(activeTab);
        </script>



        <script>


            function filterBooks() {
                const query = document.getElementById('bookSearch').value.toLowerCase();
                const rows = document.querySelectorAll('#booksTable tbody tr');
                rows.forEach(row => {
                    const title = row.dataset.title || '';
                    const author = row.dataset.author || '';
                    const visible = title.toLowerCase().includes(query) || author.toLowerCase().includes(query);
                    row.style.display = visible ? '' : 'none';
                });
            }

            function openModal(modalId) {
                document.getElementById(modalId).style.display = 'block';
            }

            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
            }

            function openEditBookModal(button) {
                const tr = button.closest('tr');
                openModal('bookModal');
                document.getElementById('bookModalTitle').innerText = 'Edit Book';
                document.getElementById('bookId').value = tr.getAttribute('data-book-id');
                document.getElementById('bookTitle').value = tr.getAttribute('data-title');
                document.getElementById('bookAuthor').value = tr.getAttribute('data-author');
                document.getElementById('bookCategory').value = tr.getAttribute('data-category');
                document.getElementById('bookStock').value = tr.getAttribute('data-stock');
                document.getElementById('bookPublisher').value = tr.getAttribute('data-publisher');
                document.getElementById('bookYear').value = tr.getAttribute('data-year');
                document.getElementById('bookPrice').value = tr.getAttribute('data-price');
                document.getElementById('editBookURL').value = tr.getAttribute('data-url');
                
            }

            // Delete confirmation
            function confirmDelete(type, id) {
                if (confirm('Are you sure you want to delete this ' + type + '?')) {
                    const form = document.getElementById('deleteForm');
                    let capitalizedType = type.charAt(0).toUpperCase() + type.slice(1);
                    document.getElementById('deleteBookAction').value = "deleteBookAction";
                    document.getElementById('deleteId').value = id;
                    form.submit();
                }
            }

            function toggleFAQ(element) {
                const faqItem = element.closest('.faq-item');
                const answer = faqItem.querySelector('.faq-answer');
                const toggle = faqItem.querySelector('.faq-toggle');

                faqItem.classList.toggle('active');
                answer.style.display = answer.style.display === 'none' ? 'block' : 'none';
            }

            function openSupportMessage(event) {
                event.preventDefault();
                document.getElementById('supportMessage').style.display = 'flex';
            }

            function closeSupportMessage() {
                document.getElementById('supportMessage').style.display = 'none';
            }
        </script>

        <%
            String successMsg = (String) session.getAttribute("Success");
            if (successMsg != null) {
                session.removeAttribute("Success"); // clear after showing
        %>
        <script>
            alert("<%= successMsg%>");
        </script>
        <% }%>

    </body>
</html>
