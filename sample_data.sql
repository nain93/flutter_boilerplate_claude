-- =================================================
-- 샘플 데이터 삽입
-- 콘텐츠 공유 앱 테스트용 데이터
-- =================================================

-- 1. 카테고리 데이터
-- =================================================
INSERT INTO public.categories (name, description, icon_url, color_code, sort_order) VALUES
('Technology', 'Latest tech trends and tutorials', 'https://cdn-icons-png.flaticon.com/512/4554/4554671.png', '#3B82F6', 1),
('Design', 'UI/UX design and creative content', 'https://cdn-icons-png.flaticon.com/512/3592/3592859.png', '#8B5CF6', 2),
('Development', 'Programming and software development', 'https://cdn-icons-png.flaticon.com/512/1005/1005141.png', '#10B981', 3),
('Mobile', 'Mobile app development and design', 'https://cdn-icons-png.flaticon.com/512/2991/2991148.png', '#F59E0B', 4),
('Web', 'Web development and technologies', 'https://cdn-icons-png.flaticon.com/512/1006/1006771.png', '#EF4444', 5),
('AI/ML', 'Artificial Intelligence and Machine Learning', 'https://cdn-icons-png.flaticon.com/512/8637/8637099.png', '#6366F1', 6),
('Tutorial', 'Step-by-step guides and tutorials', 'https://cdn-icons-png.flaticon.com/512/3074/3074058.png', '#EC4899', 7),
('News', 'Latest industry news and updates', 'https://cdn-icons-png.flaticon.com/512/833/833472.png', '#14B8A6', 8)
ON CONFLICT (name) DO NOTHING;

-- 2. 태그 데이터
-- =================================================
INSERT INTO public.tags (name) VALUES
('flutter'), ('dart'), ('react'), ('javascript'), ('typescript'),
('python'), ('nodejs'), ('firebase'), ('supabase'), ('mongodb'),
('postgresql'), ('mysql'), ('docker'), ('kubernetes'), ('aws'),
('gcp'), ('azure'), ('github'), ('gitlab'), ('ci-cd'),
('testing'), ('debugging'), ('performance'), ('security'), ('api'),
('rest'), ('graphql'), ('microservices'), ('architecture'), ('clean-code'),
('design-patterns'), ('algorithms'), ('data-structures'), ('frontend'), ('backend'),
('fullstack'), ('mobile'), ('ios'), ('android'), ('web'),
('ui-ux'), ('figma'), ('sketch'), ('adobe-xd'), ('photoshop'),
('illustrator'), ('css'), ('html'), ('sass'), ('tailwind'),
('bootstrap'), ('material-design'), ('animation'), ('responsive'), ('accessibility'),
('seo'), ('pwa'), ('spa'), ('ssr'), ('jamstack'),
('machine-learning'), ('artificial-intelligence'), ('deep-learning'), ('tensorflow'), ('pytorch'),
('data-science'), ('big-data'), ('analytics'), ('visualization'), ('blockchain'),
('cryptocurrency'), ('nft'), ('web3'), ('defi'), ('smart-contracts'),
('devops'), ('linux'), ('windows'), ('macos'), ('terminal'),
('bash'), ('powershell'), ('vim'), ('vscode'), ('intellij'),
('productivity'), ('career'), ('freelancing'), ('startup'), ('business'),
('marketing'), ('social-media'), ('content-creation'), ('blogging'), ('writing'),
('photography'), ('video-editing'), ('streaming'), ('podcast'), ('youtube'),
('beginner'), ('intermediate'), ('advanced'), ('tips'), ('tricks'),
('best-practices'), ('code-review'), ('refactoring'), ('optimization'), ('monitoring'),
('logging'), ('error-handling'), ('documentation'), ('open-source'), ('community')
ON CONFLICT (name) DO NOTHING;

-- 3. 기존 사용자들에게 추가 정보 업데이트
-- =================================================
UPDATE public.users SET 
    bio = CASE 
        WHEN name = 'John Doe' THEN 'Senior Flutter Developer passionate about clean architecture and best practices. Building the future one widget at a time.'
        WHEN name = 'Jane Smith' THEN 'UI/UX Designer & Frontend Developer. Creating beautiful and functional user experiences for mobile and web.'
        WHEN name = 'Mike Johnson' THEN 'Full-stack developer with expertise in modern web technologies. Open source contributor and tech blogger.'
        WHEN name = 'Sarah Wilson' THEN 'Mobile app developer and startup founder. Helping businesses digitize with cutting-edge mobile solutions.'
        WHEN name = 'David Brown' THEN 'DevOps engineer and cloud architect. Passionate about automation, scalability, and developer experience.'
        ELSE bio
    END,
    profile_image_url = CASE 
        WHEN name = 'John Doe' THEN 'https://picsum.photos/200/200?random=101'
        WHEN name = 'Jane Smith' THEN 'https://picsum.photos/200/200?random=102'
        WHEN name = 'Mike Johnson' THEN 'https://picsum.photos/200/200?random=103'
        WHEN name = 'Sarah Wilson' THEN 'https://picsum.photos/200/200?random=104'
        WHEN name = 'David Brown' THEN 'https://picsum.photos/200/200?random=105'
        ELSE profile_image_url
    END,
    is_verified = CASE 
        WHEN name IN ('John Doe', 'Jane Smith') THEN true
        ELSE false
    END
WHERE name IN ('John Doe', 'Jane Smith', 'Mike Johnson', 'Sarah Wilson', 'David Brown');

-- 4. 확장된 콘텐츠 데이터
-- =================================================
WITH user_category_data AS (
  SELECT 
    u.id as user_id,
    u.name as author_name,
    c.id as category_id,
    ROW_NUMBER() OVER (ORDER BY u.created_at) as user_rank
  FROM public.users u
  CROSS JOIN public.categories c
  WHERE u.name IN ('John Doe', 'Jane Smith', 'Mike Johnson', 'Sarah Wilson', 'David Brown')
    AND c.name IN ('Technology', 'Design', 'Development', 'Mobile', 'Web')
  LIMIT 20
),
content_data AS (
  SELECT 
    user_id,
    author_name,
    category_id,
    CASE user_rank
        WHEN 1 THEN 'Building Scalable Flutter Apps with Clean Architecture'
        WHEN 2 THEN 'Advanced State Management Patterns in Flutter'
        WHEN 3 THEN 'Creating Beautiful Animations in Flutter'
        WHEN 4 THEN 'Flutter Performance Optimization Techniques'
        WHEN 5 THEN 'Implementing Real-time Features with Supabase'
        WHEN 6 THEN 'Modern UI Design Principles for Mobile Apps'
        WHEN 7 THEN 'Building Responsive Web Apps with Flutter'
        WHEN 8 THEN 'Advanced Dart Programming Techniques'
        WHEN 9 THEN 'Microservices Architecture with Node.js'
        WHEN 10 THEN 'Building Progressive Web Apps with React'
        WHEN 11 THEN 'Database Design Best Practices'
        WHEN 12 THEN 'API Security and Authentication'
        WHEN 13 THEN 'CI/CD Pipeline Setup for Mobile Apps'
        WHEN 14 THEN 'Docker Containerization for Developers'
        WHEN 15 THEN 'Cloud Architecture on AWS'
        WHEN 16 THEN 'Machine Learning with Python'
        WHEN 17 THEN 'GraphQL API Development'
        WHEN 18 THEN 'Testing Strategies for Flutter Apps'
        WHEN 19 THEN 'Building Cross-platform Apps'
        WHEN 20 THEN 'DevOps Best Practices'
        ELSE 'Sample Content Title'
    END as title,
    CASE user_rank
        WHEN 1 THEN 'Learn how to structure your Flutter applications using Clean Architecture principles. This comprehensive guide covers domain, data, and presentation layers with practical examples and best practices for maintainable code.'
        WHEN 2 THEN 'Explore advanced state management patterns in Flutter including BLoC, Riverpod, and custom solutions. Learn when to use each pattern and how to implement them effectively in large-scale applications.'
        WHEN 3 THEN 'Master the art of creating smooth, performant animations in Flutter. From basic implicit animations to complex custom transitions, this guide covers everything you need to know.'
        WHEN 4 THEN 'Optimize your Flutter app performance with proven techniques. Learn about widget rebuilds, memory management, and profiling tools to create lightning-fast mobile applications.'
        WHEN 5 THEN 'Integrate real-time features into your Flutter app using Supabase. Learn about real-time subscriptions, live data updates, and building collaborative features.'
        WHEN 6 THEN 'Discover modern UI design principles that create intuitive and beautiful mobile experiences. Learn about color theory, typography, spacing, and user psychology.'
        WHEN 7 THEN 'Build responsive web applications using Flutter Web. Learn about adaptive layouts, responsive design patterns, and web-specific optimizations for Flutter.'
        WHEN 8 THEN 'Deep dive into advanced Dart programming concepts including mixins, extensions, generics, and asynchronous programming patterns for better code quality.'
        WHEN 9 THEN 'Design and implement scalable microservices architecture using Node.js. Learn about service communication, data consistency, and deployment strategies.'
        WHEN 10 THEN 'Create modern Progressive Web Apps using React. Learn about service workers, offline functionality, and native-like experiences in the browser.'
        WHEN 11 THEN 'Master database design principles for scalable applications. Learn about normalization, indexing, relationships, and performance optimization strategies.'
        WHEN 12 THEN 'Implement robust API security measures including authentication, authorization, rate limiting, and protection against common vulnerabilities.'
        WHEN 13 THEN 'Set up automated CI/CD pipelines for mobile app development. Learn about testing automation, deployment strategies, and continuous integration best practices.'
        WHEN 14 THEN 'Containerize your applications using Docker for consistent development and deployment environments. Learn about multi-stage builds and orchestration.'
        WHEN 15 THEN 'Design scalable cloud architectures on AWS. Learn about services selection, cost optimization, security, and best practices for cloud-native applications.'
        WHEN 16 THEN 'Get started with machine learning using Python. Learn about data preprocessing, model training, evaluation, and deployment of ML models in production.'
        WHEN 17 THEN 'Build efficient GraphQL APIs with modern tools and best practices. Learn about schema design, resolvers, caching, and performance optimization.'
        WHEN 18 THEN 'Implement comprehensive testing strategies for Flutter applications including unit tests, widget tests, and integration tests for reliable code.'
        WHEN 19 THEN 'Build cross-platform applications that work seamlessly across iOS, Android, and web. Learn about platform-specific optimizations and shared code strategies.'
        WHEN 20 THEN 'Implement DevOps best practices for improved development workflow. Learn about automation, monitoring, infrastructure as code, and team collaboration.'
        ELSE 'This is a comprehensive guide covering important development concepts and practical implementation strategies.'
    END as description,
    'https://picsum.photos/800/600?random=' || (user_rank + 200) as image_url,
    CASE (user_rank % 4)
        WHEN 0 THEN 'article'
        WHEN 1 THEN 'image'
        WHEN 2 THEN 'video'
        ELSE 'article'
    END as content_type,
    (user_rank * 7 + 15) as likes,
    (user_rank * 23 + 150) as views,
    (user_rank % 5 + 1) as comments_count,
    (user_rank % 3 + 1) as bookmarks_count,
    user_rank
  FROM user_category_data
)
INSERT INTO public.contents (
    title, description, image_url, author_id, author_name, 
    content_type, likes, views, comments_count, bookmarks_count,
    created_at, updated_at
)
SELECT 
    title, description, image_url, user_id, author_name,
    content_type, likes, views, comments_count, bookmarks_count,
    NOW() - INTERVAL '1 day' * (user_rank % 30),
    NOW() - INTERVAL '1 day' * (user_rank % 30)
FROM content_data;

-- 5. 콘텐츠-카테고리 연결
-- =================================================
WITH content_categories_data AS (
  SELECT 
    c.id as content_id,
    cat.id as category_id,
    ROW_NUMBER() OVER (ORDER BY c.created_at) as content_rank
  FROM public.contents c
  CROSS JOIN public.categories cat
  WHERE cat.name IN (
    CASE (ROW_NUMBER() OVER (ORDER BY c.created_at) % 5)
      WHEN 0 THEN 'Technology'
      WHEN 1 THEN 'Development' 
      WHEN 2 THEN 'Mobile'
      WHEN 3 THEN 'Web'
      ELSE 'Design'
    END
  )
)
INSERT INTO public.content_categories (content_id, category_id)
SELECT DISTINCT content_id, category_id
FROM content_categories_data;

-- 6. 콘텐츠-태그 연결
-- =================================================
WITH content_tags_data AS (
  SELECT 
    c.id as content_id,
    t.id as tag_id,
    ROW_NUMBER() OVER (ORDER BY c.created_at) as content_rank
  FROM public.contents c
  CROSS JOIN public.tags t
  WHERE t.name IN (
    CASE (ROW_NUMBER() OVER (ORDER BY c.created_at) % 10)
      WHEN 0 THEN 'flutter'
      WHEN 1 THEN 'dart'
      WHEN 2 THEN 'clean-architecture'
      WHEN 3 THEN 'mobile'
      WHEN 4 THEN 'state-management'
      WHEN 5 THEN 'ui-ux'
      WHEN 6 THEN 'performance'
      WHEN 7 THEN 'animation'
      WHEN 8 THEN 'supabase'
      ELSE 'best-practices'
    END
  )
)
INSERT INTO public.content_tags (content_id, tag_id)
SELECT content_id, tag_id
FROM content_tags_data
LIMIT 100;

-- 7. 팔로우 관계 생성
-- =================================================
WITH follow_relationships AS (
  SELECT 
    u1.id as follower_id,
    u2.id as following_id
  FROM public.users u1
  CROSS JOIN public.users u2
  WHERE u1.id != u2.id
    AND u1.name IN ('John Doe', 'Jane Smith', 'Mike Johnson')
    AND u2.name IN ('Sarah Wilson', 'David Brown', 'John Doe', 'Jane Smith')
    AND u1.id != u2.id
)
INSERT INTO public.follows (follower_id, following_id)
SELECT DISTINCT follower_id, following_id
FROM follow_relationships
LIMIT 10;

-- 8. 콘텐츠 좋아요 생성
-- =================================================
WITH content_likes_data AS (
  SELECT 
    c.id as content_id,
    u.id as user_id,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as random_order
  FROM public.contents c
  CROSS JOIN public.users u
  WHERE c.author_id != u.id
)
INSERT INTO public.content_likes (content_id, user_id)
SELECT content_id, user_id
FROM content_likes_data
WHERE random_order <= 3
LIMIT 50;

-- 9. 콘텐츠 북마크 생성
-- =================================================
WITH content_bookmarks_data AS (
  SELECT 
    c.id as content_id,
    u.id as user_id,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as random_order
  FROM public.contents c
  CROSS JOIN public.users u
  WHERE c.author_id != u.id
)
INSERT INTO public.content_bookmarks (content_id, user_id)
SELECT content_id, user_id
FROM content_bookmarks_data
WHERE random_order <= 2
LIMIT 30;

-- 10. 댓글 생성
-- =================================================
WITH comment_data AS (
  SELECT 
    c.id as content_id,
    u.id as user_id,
    u.name as user_name,
    ROW_NUMBER() OVER (ORDER BY c.created_at, u.created_at) as comment_rank
  FROM public.contents c
  CROSS JOIN public.users u
  WHERE c.author_id != u.id
  LIMIT 40
)
INSERT INTO public.comments (content_id, user_id, content)
SELECT 
  content_id,
  user_id,
  CASE (comment_rank % 8)
    WHEN 0 THEN 'Great article! Very helpful and well-explained. Thanks for sharing this valuable content.'
    WHEN 1 THEN 'This is exactly what I was looking for. The examples are clear and easy to follow.'
    WHEN 2 THEN 'Excellent work! I''ve been struggling with this concept and your explanation made it crystal clear.'
    WHEN 3 THEN 'Thanks for the detailed tutorial. I was able to implement this in my project successfully.'
    WHEN 4 THEN 'Really appreciate the practical approach. The code examples are very useful.'
    WHEN 5 THEN 'Outstanding content! This should be bookmarked by every developer working with Flutter.'
    WHEN 6 THEN 'Love the clean code approach you''ve demonstrated. Looking forward to more content like this.'
    ELSE 'Fantastic explanation! This helped me understand the concepts much better. Keep up the great work!'
  END
FROM comment_data;

-- 11. 답글 생성 (일부 댓글에 대한 답글)
-- =================================================
WITH reply_data AS (
  SELECT 
    com.id as parent_comment_id,
    com.content_id,
    u.id as user_id,
    ROW_NUMBER() OVER (ORDER BY com.created_at) as reply_rank
  FROM public.comments com
  CROSS JOIN public.users u
  WHERE com.user_id != u.id
  LIMIT 15
)
INSERT INTO public.comments (content_id, user_id, parent_comment_id, content)
SELECT 
  content_id,
  user_id,
  parent_comment_id,
  CASE (reply_rank % 5)
    WHEN 0 THEN 'Thank you for the feedback! I''m glad you found it helpful.'
    WHEN 1 THEN 'You''re absolutely right! I should have mentioned that point as well.'
    WHEN 2 THEN 'Great question! Let me clarify that part in more detail...'
    WHEN 3 THEN 'I appreciate your input. That''s definitely another approach worth considering.'
    ELSE 'Thanks for reading and commenting! Feel free to reach out if you have more questions.'
  END
FROM reply_data;

-- 12. 댓글 좋아요 생성
-- =================================================
WITH comment_likes_data AS (
  SELECT 
    com.id as comment_id,
    u.id as user_id,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as random_order
  FROM public.comments com
  CROSS JOIN public.users u
  WHERE com.user_id != u.id
)
INSERT INTO public.comment_likes (comment_id, user_id)
SELECT comment_id, user_id
FROM comment_likes_data
WHERE random_order <= 2
LIMIT 25;

-- 13. 알림 생성 (일부 샘플 알림)
-- =================================================
WITH notification_data AS (
  SELECT 
    u1.id as user_id,
    u2.id as actor_id,
    u2.name as actor_name,
    c.id as content_id,
    c.title as content_title,
    ROW_NUMBER() OVER (ORDER BY u1.created_at, u2.created_at) as notif_rank
  FROM public.users u1
  CROSS JOIN public.users u2
  CROSS JOIN public.contents c
  WHERE u1.id != u2.id AND c.author_id = u1.id
  LIMIT 20
)
INSERT INTO public.notifications (user_id, actor_id, type, title, message, entity_type, entity_id, is_read)
SELECT 
  user_id,
  actor_id,
  CASE (notif_rank % 4)
    WHEN 0 THEN 'like'
    WHEN 1 THEN 'comment'
    WHEN 2 THEN 'follow'
    ELSE 'bookmark'
  END,
  CASE (notif_rank % 4)
    WHEN 0 THEN 'Someone liked your content'
    WHEN 1 THEN 'New comment on your content'
    WHEN 2 THEN 'New follower'
    ELSE 'Someone bookmarked your content'
  END,
  CASE (notif_rank % 4)
    WHEN 0 THEN actor_name || ' liked your content: ' || content_title
    WHEN 1 THEN actor_name || ' commented on: ' || content_title
    WHEN 2 THEN actor_name || ' started following you'
    ELSE actor_name || ' bookmarked: ' || content_title
  END,
  CASE (notif_rank % 4)
    WHEN 0 THEN 'content'
    WHEN 1 THEN 'content'
    WHEN 2 THEN 'user'
    ELSE 'content'
  END,
  CASE (notif_rank % 4)
    WHEN 2 THEN actor_id
    ELSE content_id
  END,
  CASE WHEN notif_rank % 3 = 0 THEN true ELSE false END
FROM notification_data;