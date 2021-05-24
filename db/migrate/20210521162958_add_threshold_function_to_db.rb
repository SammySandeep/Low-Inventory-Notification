class AddThresholdFunctionToDb < ActiveRecord::Migration[5.2]
  def up
    connection.execute(
      "CREATE FUNCTION threshold(local_threshold int, global_threshold int)
      RETURNS int AS $$
      DECLARE threshold int;
      BEGIN
      SELECT
        CASE
          WHEN local_threshold IS NULL THEN global_threshold
          ELSE local_threshold
        END
      INTO threshold;
        
      RETURN threshold;
      END;
      $$  LANGUAGE plpgsql;"
    )
  end

  def down
    connection.execute("CREATE FUNCTION threshold")
  end
end
