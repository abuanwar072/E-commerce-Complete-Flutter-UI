import 'package:flutter/material.dart';

import '../constants.dart';

class OrderProgress extends StatelessWidget {
  const OrderProgress({
    super.key,
    required this.orderStatus,
    required this.processingStatus,
    required this.packedStatus,
    required this.shippedStatus,
    required this.deliveredStatus,
    this.isCanceled = false,
  });

  final OrderProcessStatus orderStatus,
      processingStatus,
      packedStatus,
      shippedStatus,
      deliveredStatus;
  final bool isCanceled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProcessDotWithLine(
            isShowLeftLine: false,
            title: "Ordered",
            status: orderStatus,
            nextStatus: processingStatus,
          ),
        ),
        Expanded(
          child: ProcessDotWithLine(
            isActive: processingStatus == OrderProcessStatus.processing,
            title: "Processing",
            status: processingStatus,
            nextStatus: packedStatus,
          ),
        ),
        Expanded(
          child: ProcessDotWithLine(
            title: "Packed",
            status: packedStatus,
            nextStatus: shippedStatus,
            isActive: packedStatus == OrderProcessStatus.processing,
          ),
        ),
        Expanded(
          child: ProcessDotWithLine(
            title: "Shipped",
            status: shippedStatus,
            nextStatus: isCanceled ? OrderProcessStatus.error : deliveredStatus,
            isActive: shippedStatus == OrderProcessStatus.processing,
          ),
        ),
        isCanceled
            ? const Expanded(
                child: ProcessDotWithLine(
                  title: "Canceled",
                  status: OrderProcessStatus.canceled,
                  isShowRightLine: false,
                  isActive: true,
                ),
              )
            : Expanded(
                child: ProcessDotWithLine(
                  title: "Delivered",
                  status: deliveredStatus,
                  isShowRightLine: false,
                  isActive: deliveredStatus == OrderProcessStatus.done,
                ),
              ),
      ],
    );
  }
}

class ProcessDotWithLine extends StatelessWidget {
  const ProcessDotWithLine({
    super.key,
    this.isShowLeftLine = true,
    this.isShowRightLine = true,
    required this.status,
    required this.title,
    this.nextStatus,
    this.isActive = false,
  });

  final bool isShowLeftLine, isShowRightLine;
  final OrderProcessStatus status;
  final OrderProcessStatus? nextStatus;
  final String title;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Theme.of(context).textTheme.bodyLarge!.color
                    : Theme.of(context).textTheme.bodyMedium!.color,
              ),
        ),
        const SizedBox(height: defaultPadding / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isShowLeftLine)
              Expanded(
                child: Container(
                  height: 2,
                  color: lineColor(context, status),
                ),
              ),
            if (!isShowLeftLine) const Spacer(),
            statusWidget(context, status),
            if (isShowRightLine)
              Expanded(
                child: Container(
                  height: 2,
                  color: nextStatus != null
                      ? lineColor(context, nextStatus!)
                      : successColor,
                ),
              ),
            if (!isShowRightLine) const Spacer(),
          ],
        )
      ],
    );
  }
}

enum OrderProcessStatus { done, processing, notDoneYeat, error, canceled }

Widget statusWidget(BuildContext context, OrderProcessStatus status) {
  switch (status) {
    case OrderProcessStatus.processing:
      return CircleAvatar(
        radius: 12,
        backgroundColor: successColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: Theme.of(context).scaffoldBackgroundColor,
            strokeWidth: 2,
          ),
        ),
      );
    case OrderProcessStatus.notDoneYeat:
      return CircleAvatar(
        radius: 12,
        backgroundColor: Theme.of(context).dividerColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      );
    case OrderProcessStatus.error:
      return CircleAvatar(
        radius: 12,
        backgroundColor: errorColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      );
    case OrderProcessStatus.canceled:
      return CircleAvatar(
        radius: 12,
        backgroundColor: errorColor,
        child: Icon(
          Icons.close,
          size: 12,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
    default:
      return CircleAvatar(
        radius: 12,
        backgroundColor: successColor,
        child: Icon(
          Icons.done,
          size: 12,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
  }
}

Color lineColor(BuildContext context, OrderProcessStatus status) {
  switch (status) {
    case OrderProcessStatus.notDoneYeat:
      return Theme.of(context).dividerColor;

    case OrderProcessStatus.error:
      return errorColor;

    case OrderProcessStatus.canceled:
      return errorColor;

    default:
      return successColor;
  }
}
