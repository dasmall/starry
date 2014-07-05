# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

bind_category_listeners = () ->
  $('.tweet .tags.dropdown li a').not('[role=divider]').on('click', update_tweet_category)
  return

bind_category_form_response_listeners = () ->
  $('.tweet .tags.dropdown form').on('ajax:success',
    (e, resp) ->
      $tweet = $('.tweet[data-id=' + resp.favorite_tweet_id + ']')
      $tags = $('.tweet .tags ul')
      
      switch resp.action
        when 'create'
          $new_tag = $('<li>', { class: "tags", data: {"category-id": resp.category.id} } ).append(
            $('<a>', { role:"menuitem" }).append(
              $('<i>', { class: "fa fa-circle" }),
              $('<span>', { class: "category" }).html(resp.category.name)
            )
          )
          $tags.append $new_tag

        when 'update'
          icon_classes = ['fa-circle', 'fa-circle-o']
          $('li[data-category-id=' + resp.category.id + '] i.fa', $tweet)
            .toggleClass(icon_classes.join ' ')
      return
  )
  return


update_tweet_category = (e) ->
  e.stopPropagation()

  $(e.delegateTarget).parent()
    .find('[type=submit]')
    .trigger('click')
  return
  

$ () ->
  bind_category_listeners()
  bind_category_form_response_listeners()
  return