<?php

declare(strict_types=1);

namespace App\Model;

use Nette;
use Nette\Database\Table\ActiveRow;
use Nette\Security\Passwords;

final class UserFacade implements Nette\Security\Authenticator
{
	public const PasswordMinLength = 7;

	private const
		TableName = 'users',
		ColumnId = 'id',
		ColumnName = 'username',
		ColumnFirstname = 'firstname',
		ColumnLastname = 'lastname',
		ColumnPasswordHash = 'password',
		ColumnEmail = 'email',
		ColumnRole = 'role';

	public function __construct(
		private Nette\Database\Explorer $database,
		private Passwords $passwords,
	) {
	}

	public function authenticate(string $username, string $password): Nette\Security\SimpleIdentity
	{
		$user = $this->database->table(self::TableName)
			->where(self::ColumnName, $username)
			->fetch();

		if (!$user) {
			throw new Nette\Security\AuthenticationException('The username is incorrect.', self::IdentityNotFound);

		} elseif (!$this->verifyPassword($user, $password)) {
			throw new Nette\Security\AuthenticationException('The password is incorrect.', self::InvalidCredential);
		}

		return $this->createIdentity($user);
	}


	public function verifyPassword(ActiveRow $user, string $password): bool
	{
		if (!$this->passwords->verify($password, $user[self::ColumnPasswordHash])) {
			return false;
		}

		if ($this->passwords->needsRehash($user[self::ColumnPasswordHash])) {
			$user->update([
				self::ColumnPasswordHash => $this->passwords->hash($password),
			]);
		}

		return true;
	}


	public function createIdentity(ActiveRow $user): Nette\Security\IIdentity
	{
		// Return user identity without the password hash
		$arr = $user->toArray();
		unset($arr[self::ColumnPasswordHash]);
		return new Nette\Security\SimpleIdentity($user[self::ColumnId], $user[self::ColumnRole], $arr);
	}


	/**
	 * Add a new user to the database.
	 * Throws a DuplicateNameException if the username is already taken.
	 */
	public function add(string $username, string $firstname, string $lastname, string $email, string $password): ActiveRow
	{
		// Validate the email format
		Nette\Utils\Validators::assert($email, 'email');

		// Attempt to insert the new user into the database
		try {
			return $this->database->table(self::TableName)->insert([
				self::ColumnName => $username,
				self::ColumnFirstname => $firstname,
				self::ColumnLastname => $lastname,
				self::ColumnPasswordHash => $this->passwords->hash($password),
				self::ColumnEmail => $email,
			]);
		} catch (Nette\Database\UniqueConstraintViolationException $e) {
			throw new DuplicateNameException;
		}
	}

	public function getUserById(int $userId)
    {
        return $this->database
            ->table('users')
            ->get($userId);
    }


	public function getUsers()
	{
		return $this->database->table('users');
	}

	public function removeUser(int $userId): bool
	{
    try {
        $user = $this->database
            ->table('users')
            ->get($userId);

        if (!$user) {
            return false;
        }

        $this->deleteCommentsUser($userId);

        $posts = $this->database
            ->table('post')
            ->where('user_id', $userId);

        foreach ($posts as $post) {
            $this->deleteCommentsPost($post->id);
            $post->delete();
        }

        $user->delete();

        return true;
    } catch (\Exception $e) {
        return false;
    }
	}

	public function deleteCommentsUser(int $userId): void
	{ 
	$this->database
		->table('comments')
		->where('user_id', $userId)
		->delete();
	}

	public function deleteCommentsPost(int $postId): void
    { 
    $this->database
        ->table('comments')
        ->where('post_id', $postId)
        ->delete();
    }
}



class DuplicateNameException extends \Exception
{
}
