### 下記のような感じで考えよう
def find_table_code(booking_id, visit_date, max_retry = 1)
  リトライ:
  画面表示 GET /booking_list/timetable/

  スケジュールID = booking_idを使用してタイムテーブルの行(schedule-id)を取得する
  IF スケジュールID == NULL
    IF タイムテーブルにはないけど画面上は存在している(席数が0の予約)
      配席されていないのでNULLを返す
    ELSE
      GOTO リトライ(1回だけ):
      失敗にする
    END
  ELSE
    処理継続
  END
end
