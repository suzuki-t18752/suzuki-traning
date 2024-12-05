# チェックボックスを１つのみしか選択出来ないようにする
```
$(function(){
  $('.select_box').on('click', function() {
    if ($(this).prop('checked')){
      $('.select_box').prop('checked', false);
      $(this).prop('checked', true);
    }
  });
});
```
