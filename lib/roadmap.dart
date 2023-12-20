import 'package:flutter/material.dart';

// Define a model for your roadmap steps.
class RoadmapStep {
  final String title;
  final String description;
  final IconData icon;
  final bool isCompleted;

  RoadmapStep({
    required this.title,
    required this.description,
    required this.icon,
    this.isCompleted = false,
  });
}

// Define a list of steps for the roadmap.
final List<RoadmapStep> roadmapSteps = [
  RoadmapStep(
    title: 'Market Research',
    description:
        'Conduct research to understand your target audience and competitors.',
    icon: Icons.search,
    isCompleted: true,
  ),
  RoadmapStep(
    title: 'Design UI/UX',
    description:
        'Create wireframes and design the user interface and experience.',
    icon: Icons.design_services,
    isCompleted: true,
  ),
  RoadmapStep(
    title: 'Develop the MVP',
    description: 'Start coding the minimum viable product with core features.',
    icon: Icons.code,
    isCompleted: true,
  ),
  RoadmapStep(
    title: 'Connect App to Firebase',
    description:
        'Set up Firebase for Apple Login and Google Login functionalities.',
    icon: Icons.fire_extinguisher,
    isCompleted: true,
  ),
  RoadmapStep(
    title: 'Embed Luma AI 3D Maps',
    description:
        'Incorporate Luma AI 3D maps into the app for an interactive user experience.',
    icon: Icons.map,
    isCompleted: true,
  ),
  RoadmapStep(
    title: 'Implement AR Camera',
    description:
        'Develop AR camera code to detect images and display corresponding 3D models.',
    icon: Icons.camera_enhance,
    isCompleted: true,
  ),
  RoadmapStep(
    title: 'Set up User Database',
    description:
        'Create a database schema and set up user accounts management.',
    icon: Icons.dns,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Connect Stripe Payments',
    description: 'Integrate Stripe for processing payments within the app.',
    icon: Icons.payment,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Artwork Acquisition',
    description: 'Procure or create artwork to be used in the app.',
    icon: Icons.brush,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Customer Acquisition',
    description: 'Develop and execute marketing strategies to acquire users.',
    icon: Icons.group_add,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Launch Beta Version',
    description: 'Release a beta version to gather user feedback.',
    icon: Icons.new_releases,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Analyze Feedback',
    description: 'Review feedback from beta users to refine the app.',
    icon: Icons.feedback,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Final Touches',
    description:
        'Polish the app based on feedback and prepare for official launch.',
    icon: Icons.thumb_up,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Optimize App Performance',
    description:
        'Ensure the app runs smoothly across different devices with minimal load times.',
    icon: Icons.speed,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'User Testing',
    description:
        'Conduct extensive user testing to identify and fix usability issues.',
    icon: Icons.check_circle_outline,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Legal Compliance',
    description:
        'Review and ensure the app complies with legal standards, including privacy laws and intellectual property rights.',
    icon: Icons.gavel,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Prepare Marketing Materials',
    description:
        'Create marketing materials such as app previews, screenshots, and promotional videos.',
    icon: Icons.campaign,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Develop a Monetization Strategy',
    description:
        'Plan and implement a monetization strategy that could include in-app purchases, subscriptions, or ads.',
    icon: Icons.monetization_on,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Gather Analytics',
    description:
        'Integrate analytics to track user engagement and app performance post-launch.',
    icon: Icons.analytics,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Official Launch',
    description: 'Launch the app to the public on app stores.',
    icon: Icons.launch,
    isCompleted: false,
  ),
  RoadmapStep(
    title: 'Post-Launch Support',
    description: 'Provide ongoing support and updates post-launch.',
    icon: Icons.support_agent,
    isCompleted: false,
  ),
];

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Development Roadmap'),
      ),
      body: ListView.builder(
        itemCount: roadmapSteps.length,
        itemBuilder: (context, index) {
          final step = roadmapSteps[index];
          return RoadmapStepCard(step: step);
        },
      ),
    );
  }
}

class RoadmapStepCard extends StatelessWidget {
  final RoadmapStep step;

  const RoadmapStepCard({Key? key, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(step.icon,
            color: step.isCompleted ? Colors.green : Colors.grey),
        title: Text(step.title),
        subtitle: Text(step.description),
        trailing: step.isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
      ),
    );
  }
}
