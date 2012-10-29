hide_already_selected_sections = ->
  selected_section_ids = []

  $(".selected-sections .section").each ->
    selected_section_ids.push $(this).data('section-id')

  $(".available-sections-table .section").each ->
    el = $(this)
    section_id = el.data('section-id')
    if selected_section_ids.indexOf(section_id) isnt -1
      el.hide()
    else
      el.show()

apply_section_cover = ->
  cover = $("<div class='sections-for-editing-cover'>Saving order...</div>")
  sections_wrapper = $(".sections-for-editing-wrapper")
  cover.css
    width: sections_wrapper.width()
    height: sections_wrapper.height()
  cover.appendTo(sections_wrapper)

remove_section_cover = ->
  $(".sections-for-editing-cover").remove();

save_sort_order = ->
  apply_section_cover()

  project_id = $(".sections-for-editing-wrapper").data('project-id')
  sections = []

  $(".section").each ->
    sections.push $(this).data('section-id')

  $.ajax
    url: "/projects/#{project_id}/sections/reorder"
    type: "POST"
    data:
      sections: sections
    success: (data) ->
      remove_section_cover()

update_section_category_dropdown_from_input = ->
  val = $("#section-category-input").val()
  option = $("#section-category-select option[value='#{val}']")

  if option.length > 0
    option.attr('selected', true)
    $("#section-category-input").hide()
  else
    $("#section-category-select option[value=Other]").attr('selected', true)
    $("#section-category-input").show()

section_category_dropdown_changed = ->
  val = $("#section-category-select").val()
  if val != "Other"
    $("#section-category-input").hide()
    $("#section-category-input").val(val)
  else
    $("#section-category-input").val('')
    $("#section-category-input").show()

$(document).on "ready pjax:success sectionsreloaded", ->
  hide_already_selected_sections()

  $(".category-sections").sortable
    forcePlaceholderSize: true

  $(".sections-for-editing").sortable
    handle: "h5"
    forcePlaceholderSize: true

  $(".sections-for-editing").bind 'sortupdate', save_sort_order

$(document).on "click", ".sections-for-editing .remove-button", (e) ->
  e.preventDefault()
  el = $(this)
  el.button('loading')
  $.ajax
    url: el.data('href')
    type: "DELETE"
    data:
      requested_html: "sections_for_editing"
    success: (data) ->
      new_sections_for_editing = $(data.sections_for_editing_html)
      $(".sections-for-editing-wrapper").replaceWith(new_sections_for_editing)
      $(document).trigger("sectionsreloaded")
      el.button('reset')

$(document).on "click", ".selected-sections .remove-button", (e) ->
  e.preventDefault()
  el = $(this)
  el.button('loading')
  $.ajax
    url: el.data('href')
    type: "DELETE"
    data:
      requested_html: "selected_sections"
    success: (data) ->
      new_selected_sections = $(data.selected_sections_html)
      $(".selected-sections").replaceWith(new_selected_sections)
      hide_already_selected_sections()

$(document).on "click", ".section .add-button", (e) ->
  e.preventDefault()
  el = $(this)
  el.button('loading')
  $.ajax
    url: el.data('href')
    type: "POST"
    success: (data) ->
      new_selected_sections = $(data.selected_sections_html)
      $(".selected-sections").replaceWith(new_selected_sections)
      hide_already_selected_sections()
      el.button('reset')

$(document).on "click", ".add-section-button", ->
  $("#edit-section-form").resetForm()
  $("#edit-section-modal").find(".modal-header h3").text("Add Section")
  $("#edit-section-modal").find(".will-fork").hide()
  $("#section-category-select").val("Deliverables")
  section_category_dropdown_changed()
  $("#edit-section-modal").modal('show')

$(document).on "click", ".edit-section-link", ->
  section = $(this).closest(".section")
  section_id = section.data('section-id')
  title = section.data('section-title')
  body = section.find(".body").html()
  category = section.closest(".category").data('name')

  if section.data('will-fork') is true
    $("#edit-section-modal").find(".will-fork").show()
  else
    $("#edit-section-modal").find(".will-fork").hide()

  $("#edit-section-modal").find(".modal-header h3").text("Edit Section '#{title}'")
  $("#edit-section-form").find("input[name=section_id]").val(section_id)
  $("#edit-section-form").find("input[name=project_section\\[section_category\\]]").val(category)
  $("#edit-section-form").find("input[name=project_section\\[title\\]]").val(title)
  $("#edit-section-form").find("textarea[name=project_section\\[body\\]]").val(body)
  update_section_category_dropdown_from_input()
  $("#edit-section-modal").modal('show')

$(document).on "submit", "#edit-section-form", (e) ->
  e.preventDefault()
  el = $(this)
  button = el.find(".save-button")
  button.button('loading')
  el.ajaxSubmit
    success: (data) ->
      new_sections_for_editing = $(data.sections_for_editing_html)
      $(".sections-for-editing-wrapper").replaceWith(new_sections_for_editing)
      $(document).trigger("sectionsreloaded")
      $("#edit-section-modal").modal('hide')
      button.button('reset')

$(document).on "submit", "#sync-with-fbo-form", (e) ->
  if !$(this).find("input[name=fbo_solnbr]").val()
    e.preventDefault()
  else
    $(this).find('button').button('loading')

$(document).on "change", "#section-category-select", section_category_dropdown_changed

####### FILL IN THE BLANKS ########

$("input[data-variable]").autoGrow
    comfortZone: 5

$(document).on "focus", "input[data-variable]", ->
  el = $(this)
  el.tooltip
    title: el.data('helper-text')
    placement: 'bottom'
    trigger: 'manual'
  el.tooltip('show')

$(document).on "keydown", "input[data-variable]", (e) ->
  if (e.keyCode == 13 || e.keyCode == 9)
    inputs = $("input[data-variable]")
    index = inputs.index(this) + 1

    while index < inputs.length
      input = $(inputs[index])
      if input.val() == ""
        e.preventDefault()
        return input.select()
      index++

$(document).on "blur", "input[data-variable]", ->
  $(this).tooltip('hide')

$(document).on "input blur", "input[data-variable]", (e) ->
  el = $(this)
  variableName = el.data('variable')
  variableValue = el.val()
  $("input[data-variable=#{variableName}]").each ->
    $(this).val(variableValue)
    $(this).trigger("input.autogrow")

####### TIMELINE ######

$(document).on "click", ".add-deliverable-button", ->
  row = $(".add-deliverable-row")
  new_row = row.clone()
  new_row.removeClass("add-deliverable-row")
  new_row.find(".datepicker").datepicker()
  new_row.appendTo(".timeline-table tbody")
  row.find("input").each ->
    $(this).val $(this).data('original-val')

$(document).on "click", ".remove-deliverable-button", ->
  $(this).closest("tr").remove();