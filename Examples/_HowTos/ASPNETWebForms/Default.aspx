﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Backload.HowTo.ASPNET.Default" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>Backload. Professional ASP.NET MVC File Upload Handler</title>
        <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
        <meta name="viewport" content="width=device-width" />
        <!-- Render bundles -->
        <asp:PlaceHolder ID="phHead" runat="server">        
            <%: System.Web.Optimization.Styles.Render("~/Content/themes/base/css") %>
            <%: System.Web.Optimization.Styles.Render("~/bundles/fileupload/bootstrap/BasicPlusUI/css") %>
            <%: System.Web.Optimization.Scripts.Render("~/bundles/modernizr") %>
        </asp:PlaceHolder>

        <!-- Optional: We use the jQuery colorbox plugin to view uploaded images when we click on it. -->
        <link href="Content/ColorBox/colorbox.css" rel="stylesheet" />
        <!-- Optional: Some styles for this demo page -->
        <link href="Content/styles.css" rel="stylesheet" />

        <noscript><link rel="stylesheet" type="text/css" href="~/Content/FileUpload/css/jquery.fileupload-ui-noscript.css" /></noscript>
        <!--[if lt IE 9]><script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
    </head>
    <body>
        <div id="body">
            <section class="content-wrapper main-content clear-fix">

                <!-- The file upload form used as target for the file upload widget -->
                <form id="fileupload" action="api/FileHandler" method="POST" enctype="multipart/form-data">
                    <!-- Redirect browsers with JavaScript disabled to the origin page -->
                    <noscript><input type="hidden" name="redirect" value="/"></noscript>
                    <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
                    <div class="row fileupload-buttonbar">
                        <div class="span7">
                            <!-- The fileinput-button span is used to style the file input field as button -->
                            <span class="btn btn-success fileinput-button">
                                <i class="icon-plus icon-white"></i>
                                <span>Add files...</span>
                                <input type="file" name="files[]" multiple>
                            </span>
                            <button type="submit" class="btn btn-primary start">
                                <i class="icon-upload icon-white"></i>
                                <span>Start upload</span>
                            </button>
                            <button type="reset" class="btn btn-warning cancel">
                                <i class="icon-ban-circle icon-white"></i>
                                <span>Cancel upload</span>
                            </button>
                            <button type="button" class="btn btn-danger delete">
                                <i class="icon-trash icon-white"></i>
                                <span>Delete</span>
                            </button>
                            <input type="checkbox" class="toggle">
                            <!-- The loading indicator is shown during file processing -->
                            <span class="fileupload-loading"></span>
                        </div>
                        <!-- The global progress information -->
                        <div class="span5 fileupload-progress fade">
                            <!-- The global progress bar -->
                            <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                                <div class="bar" style="width:0%;"></div>
                            </div>
                            <!-- The extended global progress information -->
                            <div class="progress-extended">&nbsp;</div>
                        </div>
                    </div>
                    <!-- The table listing the files available for upload/download -->
                    <table role="presentation" class="table table-striped"><tbody class="files" data-toggle="modal-gallery" data-target="#modal-gallery"></tbody></table>
                </form>


                <!-- The template to display files available for upload -->
                <script id="template-upload" type="text/x-tmpl">
                {% for (var i=0, file; file=o.files[i]; i++) { %}
                    <tr class="template-upload fade">
                        <td>
                            <span class="preview"></span>
                        </td>
                        <td>
                            <p class="name">{%=file.name%}</p>
                            {% if (file.error) { %}
                                <div><span class="label label-important">Error</span> {%=file.error%}</div>
                            {% } %}
                        </td>
                        <td>
                            <p class="size">{%=o.formatFileSize(file.size)%}</p>
                            {% if (!o.files.error) { %}
                                <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="bar" style="width:0%;"></div></div>
                            {% } %}
                        </td>
                        <td>
                            {% if (!o.files.error && !i && !o.options.autoUpload) { %}
                                <button class="btn btn-primary start">
                                    <i class="icon-upload icon-white"></i>
                                    <span>Start</span>
                                </button>
                            {% } %}
                            {% if (!i) { %}
                                <button class="btn btn-warning cancel">
                                    <i class="icon-ban-circle icon-white"></i>
                                    <span>Cancel</span>
                                </button>
                            {% } %}
                        </td>
                    </tr>
                {% } %}
                </script>

                <!-- The template to display files available for download -->
                <script id="template-download" type="text/x-tmpl">
                {% for (var i=0, file; file=o.files[i]; i++) { %}
                    <tr class="template-download fade" data-type="{%=file.extra_info.main_type%}">
                        <td>
                            <span class="preview">
                                {% if (file.thumbnail_url) { %}
                                    <a href="{%=file.url%}" title="{%=file.name%}" data-gallery="gallery" download="{%=file.name%}"><img src="{%=file.thumbnail_url%}"></a>
                                {% } %}
                            </span>
                        </td>
                        <td>
                            <p class="name">
                                <a href="{%=file.url%}" title="{%=file.name%}" data-gallery="{%=file.thumbnail_url&&'gallery'%}" download="{%=file.name%}">{%=file.name%}</a>
                            </p>
                            {% if (file.error) { %}
                                <div><span class="label label-important">Error</span> {%=file.error%}</div>
                            {% } %}
                        </td>
                        <td>
                            <span class="size">{%=o.formatFileSize(file.size)%}</span>
                        </td>
                        <td>
                            <button class="btn btn-danger delete" data-type="{%=file.delete_type%}" data-url="{%=file.delete_url%}"{% if (file.delete_with_credentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
                                <i class="icon-trash icon-white"></i>
                                <span>Delete</span>
                            </button>
                            <input type="checkbox" name="delete" value="1" class="toggle">
                        </td>
                    </tr>
                {% } %}
                </script>
                <!-- END: jQuery Fle Upload Plugin -->

            </section>
        </div>
        <!-- Render bundles -->
        <asp:PlaceHolder ID="phBottom" runat="server">   
            <%: System.Web.Optimization.Scripts.Render("~/bundles/jquery") %>
            <%: System.Web.Optimization.Scripts.Render("~/bundles/jqueryui") %>
            <%: System.Web.Optimization.Scripts.Render("~/bundles/fileupload/bootstrap/BasicPlusUI/js") %>
        </asp:PlaceHolder>

        <!-- Optional: We use the jQuery colorbox plugin to view uploaded images when we click on it. -->
        <script src="Scripts/ColorBox/jquery.colorbox-min.js"></script>
        <script type="text/javascript" src="Scripts/main.js"></script>
    </body>
</html>
