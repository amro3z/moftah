import 'package:flutter/material.dart';
import 'package:moftah/data/models/chat_screen_model.dart';

class TechnicianProfileModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String governorate;
  final List<String> specialties;
  final double rating;
  final int completedJobs;

  const TechnicianProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.governorate,
    required this.specialties,
    required this.rating,
    required this.completedJobs,
  });
}

enum TechnicianRequestStatus { newRequest, offerSent, accepted, inProgress, completed, rejected }

class TechnicianRequestModel {
  final String id;
  final String customerName;
  final String vehicleName;
  final String vehicleYear;
  final String issueTitle;
  final String issueDescription;
  final String location;
  final double distanceKm;
  final String createdAt;
  final String riskLabel;
  final String? aiAnalysis;
  final List<String> tags;
  final List<String> imageUrls;
  final TechnicianRequestStatus status;
  final double? inspectionFee;
  final double? minCost;
  final double? maxCost;
  final String? estimatedDuration;
  final String? warranty;
  final String? offerNotes;

  const TechnicianRequestModel({
    required this.id,
    required this.customerName,
    required this.vehicleName,
    required this.vehicleYear,
    required this.issueTitle,
    required this.issueDescription,
    required this.location,
    required this.distanceKm,
    required this.createdAt,
    required this.riskLabel,
    this.aiAnalysis,
    this.tags = const [],
    this.imageUrls = const [],
    this.status = TechnicianRequestStatus.newRequest,
    this.inspectionFee,
    this.minCost,
    this.maxCost,
    this.estimatedDuration,
    this.warranty,
    this.offerNotes,
  });

  TechnicianRequestModel copyWith({
    TechnicianRequestStatus? status,
    double? inspectionFee,
    double? minCost,
    double? maxCost,
    String? estimatedDuration,
    String? warranty,
    String? offerNotes,
  }) => TechnicianRequestModel(
        id: id,
        customerName: customerName,
        vehicleName: vehicleName,
        vehicleYear: vehicleYear,
        issueTitle: issueTitle,
        issueDescription: issueDescription,
        location: location,
        distanceKm: distanceKm,
        createdAt: createdAt,
        riskLabel: riskLabel,
        aiAnalysis: aiAnalysis,
        tags: tags,
        imageUrls: imageUrls,
        status: status ?? this.status,
        inspectionFee: inspectionFee ?? this.inspectionFee,
        minCost: minCost ?? this.minCost,
        maxCost: maxCost ?? this.maxCost,
        estimatedDuration: estimatedDuration ?? this.estimatedDuration,
        warranty: warranty ?? this.warranty,
        offerNotes: offerNotes ?? this.offerNotes,
      );
}

class TechnicianConversationModel {
  final String id;
  final String customerName;
  final String subtitle;
  final String lastMessage;
  final String time;
  final String requestId;

  const TechnicianConversationModel({
    required this.id,
    required this.customerName,
    required this.subtitle,
    required this.lastMessage,
    required this.time,
    required this.requestId,
  });

  ChatScreenModel toChat(TechnicianRequestModel request) => ChatScreenModel(
        participantId: id,
        participantName: customerName,
        subtitle: subtitle,
        requestId: request.id,
        requestTitle: request.issueTitle,
        requestDetailsRoute: '/technician/request-details',
        initialMessages: [
          ChatSeedMessageModel(text: lastMessage, isMine: false, time: time),
        ],
      );
}

class TechnicianAppBarModel {
  final TechnicianProfileModel technician;
  final int newRequests;
  final int pendingOffers;
  final int todayJobs;
  final double todayEarnings;

  const TechnicianAppBarModel({
    required this.technician,
    required this.newRequests,
    required this.pendingOffers,
    required this.todayJobs,
    required this.todayEarnings,
  });
}

class TechnicianNavItemModel {
  final String label;
  final IconData icon;
  const TechnicianNavItemModel(this.label, this.icon);
}
