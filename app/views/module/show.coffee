View = require '../base/view'
Editor = require '../../lib/editor'
ThingsList  = require '../thing/index'
EditThingsList  = require '../thing/index-edit'
$ = require 'jquery'

module.exports = class ModuleView extends View
  autoRender: true
  className: 'container'
  regions:
    left: '#left'
    right: '#right'
  template: require '../../templates/module/show'
  events:
    'click button#edit': 'edit'
    'click button#save': 'save'
    'keyup .io': 'add'
    'click button.remove': 'remove'
  render: ->
    super
    console.log 'render'
  edit: (e) ->
    console.log 'edit'
    $('button#edit').hide()
    $('button#save').show()
    Editor.edit 'name', 'input'
    Editor.edit 'description', 'textarea'
    Editor.edit 'process', 'textarea'
    $('#left').append '<input type="input" property="input" class="edit io form-control" placeholder="new intput">'
    $('#right').append '<input type="input" property="output" class="edit io form-control" placeholder="new output">'
    @subview 'input',  new EditThingsList collection: @model.input, region: 'left'
    @subview 'output',  new EditThingsList collection: @model.output, region: 'right'
  save: (e) ->
    console.log 'save'
    $('button#save').hide()
    $('button#edit').show()
    $('.edit').hide()
    Editor.save 'name'
    Editor.save 'description'
    Editor.save 'process'
    $('#left input, #right input').remove()
    @subview 'input',  new ThingsList collection: @model.input, region: 'left'
    @subview 'output',  new ThingsList collection: @model.output, region: 'right'
  add: (e) ->
    if e.keyCode == 13
      console.log e.target
      if e.target.attributes.property.value == 'input'
        @model.input.add { name: e.target.value } if e.target.value != ""
        console.log 'input', @model.input
      else
        @model.output.add { name: e.target.value } if e.target.value != ""
        console.log 'output', @model.output
      e.target.value = ''
  remove: (e) ->
    uri = $($(e.target).parent()).find('a').attr('href').split('/').pop()
    console.log(uri)
    model = @model.input.find (obj) -> obj.id == uri
    if model
      @model.input.remove model
    else
      model = @model.output.find (obj) -> obj.id == uri
      @model.output.remove model
  listen:
    'addedToDOM': 'hide'
  hide: ->
    $('button#save').hide()
