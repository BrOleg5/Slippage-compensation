#ifndef MEASUREMENTS_LIB
#define MEASUREMENTS_LIB

#define PI 3.14159265
#define MMperPIX 2.0757

#include "opencv2/aruco.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"

namespace td {
	struct TransferData {
		cv::Point2d currGlobalCartesian;
		cv::Point2d prevGlobalCartesian;
		double currAngle;
		double prevAngle;
		double deltaAngle;
		cv::Point2d deltaEigenCartesian;
		void Angle(TransferData* transfer, cv::Point2d* arucoCorner);
		void DeltaEigen(TransferData* transfer);
	};
}

double getTime(std::chrono::time_point<std::chrono::steady_clock> timePoint1);

#endif