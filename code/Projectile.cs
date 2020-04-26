using Godot;
using System;

public class Projectile : KinematicBody2D
{
	float radius;
	Color color;
	float seek_amount;
	Vector2 velocity;
	string ownership = "enemy";
	float dmg = 25.0f;
	CollisionShape2D hitbox;
	Node layers;
	Node game;
	
	public override void _Ready()
	{
		hitbox = GetNode<CollisionShape2D>("hitbox");
		(hitbox.Shape as CircleShape2D).Radius = radius; // ????
		
		layers = GetNode("/root/Layers");
		game = GetNode("/root/Game");
		
		switch (ownership)
		{
			case "player":
				GetNode<Sprite>("main_sprites/player_sprite").Show();
				CollisionMask = 6;
				break;
			case "enemy":
				GetNode<Sprite>("main_sprites/enemy_sprite").Show();
				CollisionMask = 5;
				break;
		}
	}

	public override void _PhysicsProcess(float delta)
	{
		Node2D screen = (Node2D)game.GetNode("ScreenBounds");
		
		if (!(bool)screen.Call("has", Position, 100)) {
			QueueFree();
			return;
		}
		
		var collision = MoveAndCollide(velocity);
		if (collision != null) {
			SetPhysicsProcess(false);
			hit(collision);
		}
	}

	private void hit(KinematicCollision2D col) {
		CollisionMask = 0;
		var colfx = GetNode<Particles2D>("collisionfx");
		colfx.Call("activate", velocity);
		if ((col.Collider as PhysicsBody2D).CollisionLayer == 1) {
			KinematicBody2D player = (KinematicBody2D)game.GetNode("ScreenBounds/Player");
			player.Call("damaged", dmg);
		}

		var tween = GetNode<Tween>("Tween");
		tween.InterpolateProperty(GetNode<Node2D>("main_sprites"), 
			"modulate", 
			new Color(1.0f,1.0f,1.0f,1.0f), 
			new Color(1.0f,1.0f,1.0f,0.0f), 
			0.2f, 
			Tween.TransitionType.Linear, 
			Tween.EaseType.Out);
		tween.Start();
	}
}
