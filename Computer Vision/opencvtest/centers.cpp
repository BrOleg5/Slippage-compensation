#define _CRT_SECURE_NO_WARNINGS

#define MMperPIX 2.0757
#define PI 3.14159265

#include <filesystem>
#include <stdio.h>
#include <fstream>
#include <iostream>
#include <string>
#include "opencv2/aruco.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2//imgproc.hpp"
#include <chrono>
#include <time.h>
#include <direct.h>
#include <Windows.h>
#include "measurements.h"

const std::string CSVheader = "TIME, sec;XPOS, pixels;YPOS, pixels;ABSANGLE, degree;RELANGLE, degree;DX, mm;DY, mm\n";
const std::string experimentDirectory = "Experiments";
HANDLE map_file;
double * data;

int main() {
	map_file = CreateFileMappingA(INVALID_HANDLE_VALUE, NULL, PAGE_READWRITE, 0, 256, "data_file");
	data = (double*)MapViewOfFile(map_file, FILE_MAP_ALL_ACCESS, 0, 0, 256);
	data[0] = 0;
	data[1] = 0;
	data[2] = 0;
	td::TransferData transfer;
	transfer.currAngle = (double)0;
	transfer.currGlobalCartesian.x = 0;
	transfer.currGlobalCartesian.y = 0;
	time_t t;
	time(&t);
	tm* s_time = localtime(&t);
	char itosbuf[2];
	const std::string dataDirectory = experimentDirectory + "/" + std::string(s_time->tm_mday < 10 ? "0" : "") + std::string(_itoa(s_time->tm_mday, itosbuf, 10)) + "." + (s_time->tm_mon + 1 < 10 ? "0" : "") + std::string(_itoa(s_time->tm_mon + 1, itosbuf, 10));
	std::ofstream csv;
	_mkdir(experimentDirectory.c_str());
	_mkdir(dataDirectory.c_str());
	// three first corners of aruco marker cartesian clockwise
	cv::Point2d arucoCorner[3];
	for (int i = 0; i < 3; i++) {
		arucoCorner[i].x = 0;
		arucoCorner[i].y = 0;
	}
	// frame for webcam capture                               
	cv::Mat currentVideoFrame;
	// resulting image to be shown                            
	cv::Mat outputImage;
	// initializing the webcam for capturing                  
	cv::VideoCapture webcam(1);
	// setting the quality 1920x1080 for the webcam           
	webcam.set(cv::CAP_PROP_FRAME_WIDTH, 1920);
	webcam.set(cv::CAP_PROP_FRAME_HEIGHT, 1080);
	webcam.set(cv::CAP_PROP_AUTOFOCUS, 0);
	webcam.set(cv::CAP_PROP_AUTO_EXPOSURE, 1);
	// vector for aruco markers' ids                          
	std::vector<int> markerIds;
	// matrix for aruco markers' actual and rejected corners  
	std::vector<std::vector<cv::Point2f>> markerCorners, rejectedCandidates;
	// checking for the webcam to be connected                
	if (!webcam.isOpened()) {
		std::cout << "Webcam Not Connected" << std::endl;
		return 0;
	}
	// creating the parameters for the aruco detection        
	cv::Ptr<cv::aruco::DetectorParameters> parameters = cv::aruco::DetectorParameters::create();
	// selecting the dictionary to use                        
	cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_4X4_50);

	if (!webcam.read(currentVideoFrame)) {
		std::cout << "Webcam Is Not Connected" << std::endl;
		return 0;
	}
	currentVideoFrame = currentVideoFrame(cv::Rect(340, 0, 1150, 1080));
	// clearing the markers' ids vector                   
	markerIds.clear();
	// detecting the aruco markers                        
	cv::aruco::detectMarkers(currentVideoFrame, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);
	// drawing the detection square in the image
	currentVideoFrame.copyTo(outputImage);
	//outputImage = currentVideoFrame.clone();
	cv::aruco::drawDetectedMarkers(outputImage, markerCorners, markerIds);
	// checking if there are any markers                  
	if (!markerIds.empty()) {
		// if yes, setting the corners' cartesian         
		for (int i = 0; i < 3; i++) {
			arucoCorner[i].x = markerCorners[0][i].x - 0.105 * (markerCorners[0][i].x - 575);
			arucoCorner[i].y = markerCorners[0][i].y - 0.105 * (markerCorners[0][i].y - 540);
		}
	}
	else {
		// if not, setting the error signal               
		for (int i = 0; i < 3; i++) {
			arucoCorner[i].x = 1;
			arucoCorner[i].y = 1;
		}
	}
	//float dist = sqrt(pow(arucoCorner[0].x - arucoCorner[1].x, 2) + pow(arucoCorner[0].y - arucoCorner[1].y, 2));
	// calculating current cartesian position in pixels 
	transfer.prevGlobalCartesian.x = transfer.currGlobalCartesian.x;
	transfer.prevGlobalCartesian.y = transfer.currGlobalCartesian.y;
	transfer.currGlobalCartesian.x = (arucoCorner[0].x + arucoCorner[2].x) / 2;
	transfer.currGlobalCartesian.y = (arucoCorner[0].y + arucoCorner[2].y) / 2;
	// finding the angle of the aruco vector              
	transfer.prevAngle = transfer.currAngle;
	transfer.Angle(&transfer, arucoCorner);
	transfer.DeltaEigen(&transfer);
	// Showing the image with the aruco code
	//cv::imshow("Press 'SPACE' to measure or 'ENTER' to exit", outputImage);
	double measure_duration = 0;
	// main infinite loop                                     
	while (1) {
		std::cout << "Enter measure time session in sec or enter 0 for escape." << std::endl;
		std::cin >> measure_duration;
		if (measure_duration > 0) {
			time(&t);
			s_time = localtime(&t);
			const std::string fileName = dataDirectory + "/" + (s_time->tm_hour < 10 ? "0" : "") + std::string(_itoa(s_time->tm_hour, itosbuf, 10)) + "-" + (s_time->tm_min < 10 ? "0" : "") + std::string(_itoa(s_time->tm_min, itosbuf, 10)) + "-" + (s_time->tm_sec < 10 ? "0" : "") + std::string(_itoa(s_time->tm_sec, itosbuf, 10)) + ".csv";
			csv.open(fileName, std::ios::out | std::ios::trunc);
			csv << CSVheader;

			// checking for the webcam to be connected            
			if (!webcam.read(currentVideoFrame)) {
				std::cout << "Webcam Is Not Connected" << std::endl;
				break;
			}
			currentVideoFrame = currentVideoFrame(cv::Rect(340, 0, 1150, 1080));
			// clearing the markers' ids vector                   
			markerIds.clear();
			// detecting the aruco markers                        
			cv::aruco::detectMarkers(currentVideoFrame, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);
			if (markerCorners.empty() == 0) {
				std::cout << "GOT DATA  ";
				// drawing the detection square in the image
				currentVideoFrame.copyTo(outputImage);
				//outputImage = currentVideoFrame.clone();
				cv::aruco::drawDetectedMarkers(outputImage, markerCorners, markerIds);
				// checking if there are any markers                  
				if (!markerIds.empty()) {
					// if yes, setting the corners' cartesian         
					for (int i = 0; i < 4; i++) {
						arucoCorner[i].x = markerCorners[0][i].x - 0.105 * (markerCorners[0][i].x - 575);
						arucoCorner[i].y = markerCorners[0][i].y - 0.105 * (markerCorners[0][i].y - 540);
						std::cout << "[ " << arucoCorner[i].x << " ; " << arucoCorner[i].y << " ] ";
					}
				}
				else {
					// if not, setting the error signal               
					for (int i = 0; i < 3; i++) {
						arucoCorner[i].x = 1;
						arucoCorner[i].y = 1;
					}
				}
				std::cout << std::endl;
				//float dist = sqrt(pow(arucoCorner[0].x - arucoCorner[1].x, 2) + pow(arucoCorner[0].y - arucoCorner[1].y, 2));
				//std::cout << dist << std::endl;
				// calculating current cartesian position in pixels 
				transfer.prevGlobalCartesian.x = transfer.currGlobalCartesian.x;
				transfer.prevGlobalCartesian.y = transfer.currGlobalCartesian.y;
				transfer.currGlobalCartesian.x = (arucoCorner[0].x + arucoCorner[2].x) / 2;
				transfer.currGlobalCartesian.y = (arucoCorner[0].y + arucoCorner[2].y) / 2;
				// finding the angle of the aruco vector              
				transfer.prevAngle = transfer.currAngle;
				transfer.Angle(&transfer, arucoCorner);
				if (abs(transfer.currAngle - transfer.prevAngle) > 160) {
					if (transfer.currAngle > transfer.prevAngle) {
						transfer.deltaAngle = -1 * (360 - transfer.currAngle + transfer.prevAngle);
					}
					else {
						transfer.deltaAngle = 360 - transfer.prevAngle + transfer.currAngle;
					}
				}
				else {
					transfer.deltaAngle = transfer.currAngle - transfer.prevAngle;
				}
				// Finding eigen cartesian delta
				transfer.DeltaEigen(&transfer);
			}

			auto timePoint1 = std::chrono::steady_clock::now();
			double current_time = getTime(timePoint1);
			while (current_time <= measure_duration) {
				// checking for the webcam to be connected            
				if (!webcam.read(currentVideoFrame)) {
					std::cout << "Webcam Is Not Connected" << std::endl;
					break;
				}
				currentVideoFrame = currentVideoFrame(cv::Rect(340, 0, 1150, 1080));
				// clearing the markers' ids vector                   
				markerIds.clear();
				// detecting the aruco markers                        
				cv::aruco::detectMarkers(currentVideoFrame, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);
				if (markerCorners.empty() == 0) {
					std::cout << "GOT DATA  ";
					// drawing the detection square in the image
					currentVideoFrame.copyTo(outputImage);
					//outputImage = currentVideoFrame.clone();
					cv::aruco::drawDetectedMarkers(outputImage, markerCorners, markerIds);
					// checking if there are any markers                  
					if (!markerIds.empty()) {
						// if yes, setting the corners' cartesian         
						for (int i = 0; i < 4; i++) {
							arucoCorner[i].x = markerCorners[0][i].x - 0.105 * (markerCorners[0][i].x - 575);
							arucoCorner[i].y = markerCorners[0][i].y - 0.105 * (markerCorners[0][i].y - 540);
							std::cout << "[ " << arucoCorner[i].x << " ; " << arucoCorner[i].y << " ] ";
						}
					}
					else {
						// if not, setting the error signal               
						for (int i = 0; i < 3; i++) {
							arucoCorner[i].x = 1;
							arucoCorner[i].y = 1;
						}
					}
					std::cout << std::endl;
					//float dist = sqrt(pow(arucoCorner[0].x - arucoCorner[1].x, 2) + pow(arucoCorner[0].y - arucoCorner[1].y, 2));
					//std::cout << dist << std::endl;
					// calculating current cartesian position in pixels 
					transfer.prevGlobalCartesian.x = transfer.currGlobalCartesian.x;
					transfer.prevGlobalCartesian.y = transfer.currGlobalCartesian.y;
					transfer.currGlobalCartesian.x = (arucoCorner[0].x + arucoCorner[2].x) / 2;
					transfer.currGlobalCartesian.y = (arucoCorner[0].y + arucoCorner[2].y) / 2;
					// finding the angle of the aruco vector              
					transfer.prevAngle = transfer.currAngle;
					transfer.Angle(&transfer, arucoCorner);
					if (abs(transfer.currAngle - transfer.prevAngle) > 160) {
						if (transfer.currAngle > transfer.prevAngle) {
							transfer.deltaAngle = -1 * (360 - transfer.currAngle + transfer.prevAngle);
						}
						else {
							transfer.deltaAngle = 360 - transfer.prevAngle + transfer.currAngle;
						}
					}
					else {
						transfer.deltaAngle = transfer.currAngle - transfer.prevAngle;
					}
					// Finding eigen cartesian delta
					transfer.DeltaEigen(&transfer);
					// Write data to .csv
					current_time = getTime(timePoint1);
					csv << current_time << ";" << (int)transfer.currGlobalCartesian.x << ";" << (int)transfer.currGlobalCartesian.y << ";" << transfer.currAngle << ";";
					csv << transfer.deltaAngle << ";";
					csv << transfer.deltaEigenCartesian.x << ";" << transfer.deltaEigenCartesian.y << std::endl;
					// Showing the image with the aruco code
					data[0] = transfer.currGlobalCartesian.x;
					data[1] = transfer.currGlobalCartesian.y;
					data[2] = transfer.currAngle;
					data[3] = transfer.deltaAngle;
					data[4] = transfer.deltaEigenCartesian.x;
					data[5] = transfer.deltaEigenCartesian.y;
					//cv::imshow("Press 'SPACE' to measure or 'ENTER' to exit", outputImage);
				}
				else {
					std::cout << "ERROR DETECTING ARUCO, TRY REPLACING ROBOTINO" << std::endl;
				}
			}
			csv.close();
		}
		else {
			break;
		}
	}
	return 0;
}