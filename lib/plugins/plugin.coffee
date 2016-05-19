{Emitter} = require 'atom'
module.exports =
class ConnectorPlugin extends Emitter
  @pluginName: "github-connector-plugin"
  @provider: "github"
  ready: false
  constructor: (@repo, @imdoneView, @connector) ->
    # We need some way to get the connector!
    super
    @ready = true
    @view = new @PluginView({@repo, @connector})
    @emit 'ready'
    @imdoneView.on 'board.update', =>
      return unless @view && @view.is ':visible'
      @imdoneView.selectTask @task.id

  PluginView: require('./plugin-view')

  # Interface ---------------------------------------------------------------------------------------------------------
  isReady: ->
    @ready
  getView: ->
    @view
  taskButton: (id) ->
    {$, $$, $$$} = require 'atom-space-pen-views'
    return unless @repo
    task = @repo.getTask(id)
    issueIds = @view.getIssueIds(task)
    title = "Update linked github issues (imdone.io)"
    self = @
    $btn = $$ ->
      @a href: '#', title: title, class: "#{self.pluginName}", =>
        @span class:"icon icon-octoface text-success"
    $btn.on 'click', (e) =>
      $(e.target).find('.task')
      @task = task
      @imdoneView.showPlugin @
      @imdoneView.selectTask id
      @view.setTask task
      @view.show issueIds