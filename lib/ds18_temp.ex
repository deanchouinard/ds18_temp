defmodule Ds18Temp do
  use Application

  @moduledoc """
    Simple example to read temperature from DS18B20 temperature sensor

    Note use of Regex.run and a regex capture to return a value from a string.

    The sysfs file contains the latest reading from the temperature sensor,
    and is not a text file of multiple readings.

    Also, Nerves uses RingLogger. You will have to enter RingLogger.attach
    in the console to see the log entries.
  """

  require Logger

  @base_dir "/sys/bus/w1/devices/"

  def start(_type, _args) do

    Logger.debug "Start measuring temperature..."

    spawn(fn ->  read_temp_forever() end)

    {:ok, self()}
  end

  defp read_temp_forever do
    File.ls!(@base_dir)
      |> Enum.filter(&(String.starts_with?(&1, "28-")))
      |> Enum.each(&read_temp(&1, @base_dir))

    :timer.sleep(1000)
    read_temp_forever()
  end

  defp read_temp(sensor, base_dir) do
    sensor_data = File.read!("#{base_dir}#{sensor}/w1_slave")
    Logger.debug("reading sensor: #{sensor}: #{sensor_data}")
    {temp, _} = Regex.run(~r/t=(\d+)/, sensor_data)
    |> List.last
    |> Float.parse
    Logger.debug "#{temp/1000} C"
  end

end
