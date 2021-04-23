#include "measurements.h"

void td::TransferData::Angle(td::TransferData* transfer, cv::Point2d* arucoCorner) {
	if (arucoCorner[1].x >= arucoCorner[2].x) {
		if (arucoCorner[1].y >= arucoCorner[2].y) {
			// if in [0 ; 90] degrees, then               
			transfer->currAngle = (double)270 - std::acos(abs(arucoCorner[1].x - arucoCorner[2].x) / sqrt(pow(arucoCorner[1].x - arucoCorner[2].x, 2) + pow(arucoCorner[1].y - arucoCorner[2].y, 2))) * (double)180 / (double)PI;
		}
		else {
			// if in [270 ; 360] degrees, then            
			transfer->currAngle = -90 + acos(abs(arucoCorner[1].x - arucoCorner[2].x) / sqrt(pow(arucoCorner[1].x - arucoCorner[2].x, 2) + pow(arucoCorner[1].y - arucoCorner[2].y, 2))) * (double)180 / (double)PI;
		}
	}
	else {
		if (arucoCorner[1].y >= arucoCorner[2].y) {
			// if in [90 ; 180] degrees, then             
			transfer->currAngle = (double)90 + acos(abs(arucoCorner[1].x - arucoCorner[2].x) / sqrt(pow(arucoCorner[1].x - arucoCorner[2].x, 2) + pow(arucoCorner[1].y - arucoCorner[2].y, 2))) * (double)180 / (double)PI;
		}
		else {
			// if in [180 ; 270] degrees, then            
			transfer->currAngle = (double)90 - acos(abs(arucoCorner[1].x - arucoCorner[2].x) / sqrt(pow(arucoCorner[1].x - arucoCorner[2].x, 2) + pow(arucoCorner[1].y - arucoCorner[2].y, 2))) * (double)180 / (double)PI;
		}
	}
	if (transfer->currAngle < 0) {
		transfer->currAngle = 360 + transfer->currAngle;
	}
	if (abs(transfer->currAngle - transfer->prevAngle) > 160) {
		if (transfer->currAngle > transfer->prevAngle) {
			transfer->deltaAngle = -1 * (360 - transfer->currAngle + transfer->prevAngle);
		}
		else {
			transfer->deltaAngle = 360 - transfer->prevAngle + transfer->currAngle;
		}
	}
	else {
		transfer->deltaAngle = transfer->currAngle - transfer->prevAngle;
	}
}

void td::TransferData::DeltaEigen(td::TransferData* transfer) {
	cv::Point2d delta;
	delta.x = transfer->currGlobalCartesian.x - transfer->prevGlobalCartesian.x;
	delta.y = transfer->currGlobalCartesian.y - transfer->prevGlobalCartesian.y;
	transfer->deltaEigenCartesian.x = (delta.x * sin(transfer->currAngle / 180 * PI) * (-1) - delta.y * cos(transfer->currAngle / 180 * PI)) * MMperPIX;
	transfer->deltaEigenCartesian.y = (delta.x * cos(transfer->currAngle / 180 * PI) * (-1) + delta.y * sin(transfer->currAngle / 180 * PI)) * MMperPIX;
}

double getTime(std::chrono::time_point<std::chrono::steady_clock> timePoint1) {
	auto timePoint2 = std::chrono::steady_clock::now();
	std::chrono::duration<float> curTime = timePoint2 - timePoint1;
	auto timePassed = curTime.count();
	return timePassed;
}