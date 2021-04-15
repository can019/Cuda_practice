## `laser_odometry_node.cpp`
<b>`[Line 8~10]`</b><br/>
`multi_scan_registragion_node` 참고
<b>'[Line 12]</b><br/>
LaserOdometry 객체 생성
  - scanPeriod을 0.1로 설정.
<b>`[Line 14~16]</b><br/>
LaserOdometry의 spin() 호출.
  - ROS의 spin이 아님을 주의.  

- - -
## `LaserOdometry.cpp`
#### 현재상황 :: `laser_odometry_node.cpp`에서 LaserOdometry 객체 생성 후 spin()함수 실행.
<b>`[Line 254~270]`</b><br/>
rate 설정하고 process()호출.
- `ros::Rate rate(double frequency);`
  - 원하는 실행 속도 설정.
  - 단위는 Hz
- `ros::ok()`
  - False를 return하는 경우
    - SIGINT
    - 같은 이름의 node가 존재하는경우
    - ros::shutdown()이 호출되는 경우
    - 모든 ros::NodeHandels가 죽는 경우.

#### 현재상황 :: `laser_odometry_node.cpp`에서 LaserOdometry 객체 생성 후 spin()함수 실행 -> process() 호출
<b>`[Line 286~294]</b></br>
LaserOdometry::hasNewData()를 호출하여 예외처리.
- hasNewData()는 이것저것 조건을 &&한 결과를 return.
  - 해당 함수는 <b>Line 273~281에 존재</b>

- reset()은hasNewDat()에서 조건검사시 사용한 변수들을 모두 false로 설정.
  - 해당 함수는 <b>Line 168~175에 존재</b>



